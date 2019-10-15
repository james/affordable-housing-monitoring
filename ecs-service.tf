resource "aws_cloudwatch_log_group" "service_logs" {
  name              = "${terraform.workspace}"
  retention_in_days = 90
}

data "template_file" "container_definition" {
  template = "${file("./container_definitions/app.json.tpl")}"

  vars = {
    image          = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${terraform.workspace}-${local.app_name}"
    container_name = "${terraform.workspace}-${local.app_name}"
    container_port = "3000"
    log_group      = "${aws_cloudwatch_log_group.service_logs.name}"
    log_region     = "${var.region}"
    entrypoint     = "${jsonencode(list("/bin/bash", "-c", join(" ", concat(local.install_postgres_cert_command, local.ssm_parameters_command, var.container_command))))}"
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name               = "${terraform.workspace}_ecs_task_execution_role"
  assume_role_policy = "${file("./policies/ecs_task_execution_role.json.tpl")}"
}

resource "aws_iam_role_policy" "ecs_execution_role_policy" {
  name   = "${terraform.workspace}_ecs_execution_role_policy"
  policy = "${file("./policies/ecs_task_execution_role_policy.json.tpl")}"
  role   = "${aws_iam_role.ecs_execution_role.id}"
}

resource "aws_iam_role" "task_role" {
  name               = "${terraform.workspace}_task_role"
  assume_role_policy = "${file("./policies/task_role.json.tpl")}"
}

data "template_file" "task_role" {
  template = "${file("./policies/task_role_policy.json.tpl")}"

  vars = {
    ssm_resource = "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${terraform.workspace}/*"
    kms_key      = "${aws_kms_key.ssm.arn}"
  }
}

resource "aws_iam_role_policy" "task_role_policy" {
  name   = "${terraform.workspace}_task_role_policy"
  policy = "${data.template_file.task_role.rendered}"
  role   = "${aws_iam_role.task_role.id}"
}

module "ecs-service" {
  source = "./vendor/terraform_modules/terraform-aws-ecs-service"

  environment = "app"

  service_name          = "${local.app_name}-${var.environment}"
  service_desired_count = 1

  vpc_id   = "${data.aws_vpc.vpc.id}"
  vpc_cidr = "${data.aws_vpc.vpc.cidr_block}"

  lb_subnetids = [
    "${element(data.aws_subnet.extra_public.*.id, 0)}",
    "${element(data.aws_subnet.extra_public.*.id, 1)}",
    "${element(data.aws_subnet.extra_public.*.id, 2)}",
  ]

  lb_internal = false

  ecs_cluster_id = "${var.cluster_name}"

  task_definition   = "${data.template_file.container_definition.rendered}"
  task_network_mode = "bridge"

  service_launch_type = "EC2"

  awsvpc_task_execution_role_arn = "${aws_iam_role.ecs_execution_role.arn}"

  task_role_arn = "${aws_iam_role.task_role.arn}"

  lb_target_group = {
    target_type          = "instance"
    container_name       = "${terraform.workspace}-${local.app_name}"
    container_port       = "3000"
    deregistration_delay = "60"
  }

  lb_health_check = [{
    path                = "/check"
    protocol            = "HTTP"
    matcher             = "200,301"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval            = 30
  }]

  lb_listener = {
    port            = 443
    protocol        = "HTTPS"
    certificate_arn = "${aws_acm_certificate.lb_certificate.arn}"
    ssl_policy      = "ELBSecurityPolicy-TLS-1-2-2017-01"
  }

  lb_security_group_ids = [
    "${data.aws_security_group.ecs_alb_security_group.id}",
    "${aws_security_group.allow80.id}",
  ]
}

module "daemon-service" {
  source = "./vendor/terraform_modules/terraform-aws-ecs-daemon-service"

  environment = "${var.environment}"

  service_name            = "${local.app_name}-daemon"
  ecs_cluster_id          = "${var.cluster_name}"
  task_definition         = "${data.template_file.container_definition.rendered}"
  task_role_arn           = "${aws_iam_role.task_role.arn}"
  task_execution_role_arn = "${aws_iam_role.ecs_execution_role.arn}"
  lb_target_group_arn     = "${module.ecs-service.lb_target_group_arn}"
  container_name          = "${terraform.workspace}-${local.app_name}"
  container_port          = "3000"
}

resource "aws_lb_listener" "port-80" {
  load_balancer_arn = "${module.ecs-service.lb_arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_security_group" "allow80" {
  name        = "${terraform.workspace}-allow-80"
  description = "Allow 80 inbound traffic"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
