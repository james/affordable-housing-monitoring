resource "aws_security_group" "rds_postgresql_sg" {
  name        = "${terraform.workspace}-rds-postgresql-sg"
  description = "${terraform.workspace} RDS PostgreSQL Security Group"
  vpc_id      = "${data.aws_vpc.vpc.id}"
}

resource "aws_security_group_rule" "rds_postgresql_sg_rule" {
  type                     = "ingress"
  from_port                = "5432"
  to_port                  = "5432"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.rds_postgresql_sg.id}"
  source_security_group_id = "${data.aws_security_group.ecs_security_group.id}"
}

module "rds_postgresql" {
  source = "./vendor/terraform_modules/terraform-aws-rds"

  identifier        = "${replace(terraform.workspace, "-", "")}ahm"
  engine            = "postgres"
  engine_version    = "${var.rds_engine_version}"
  instance_class    = "${var.rds_instance_class}"
  allocated_storage = "${var.rds_allocated_storage}"

  name     = "${var.rds_db_name}"
  username = "${var.rds_db_username}"
  password = "${var.rds_db_password}"
  port     = "5432"

  vpc_security_group_ids = ["${aws_security_group.rds_postgresql_sg.id}"]

  maintenance_window = "${var.rds_maintenance_window}"
  backup_window      = "${var.rds_backup_window}"

  subnet_ids = [
    "${element(data.aws_subnet.ecs_private.*.id, 0)}",
    "${element(data.aws_subnet.ecs_private.*.id, 1)}",
  ]

  availability_zone = "${element(data.aws_subnet.ecs_private.*.availability_zone, 0)}"

  family = "${var.rds_db_parameter_group}"

  final_snapshot_identifier = "${terraform.workspace}-final"

  parameters = [
    {
      name  = "rds.force_ssl"
      value = 1
    },
  ]

  apply_immediately = true
}
