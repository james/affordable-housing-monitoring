locals {
  shared_infrastructure_name = "dalmatian-1"
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${local.shared_infrastructure_name}-ecs-${var.environment}-ecs-vpc"]
  }
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = "${var.cluster_name}"
}

data "aws_subnet" "ecs_private" {
  count = "${length(var.ecs_private_subnets)}"

  filter {
    name   = "cidr-block"
    values = ["${lookup(var.ecs_private_subnets[count.index], "cidr")}"]
  }

  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.vpc.id}"]
  }
}

data "aws_route_table" "private_subnet_route_table" {
  subnet_id = "${element(data.aws_subnet.ecs_private.*.id, 0)}"
}

data "aws_subnet" "ecs_public" {
  count = "${length(var.ecs_public_subnets)}"

  filter {
    name   = "cidr-block"
    values = ["${lookup(var.ecs_public_subnets[count.index], "cidr")}"]
  }

  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.vpc.id}"]
  }
}

data "aws_subnet" "extra_private" {
  count = "${length(var.extra_private_subnets)}"

  filter {
    name   = "cidr-block"
    values = ["${lookup(var.extra_private_subnets[count.index], "cidr")}"]
  }

  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.vpc.id}"]
  }
}

data "aws_subnet" "extra_public" {
  count = "${length(var.extra_public_subnets)}"

  filter {
    name   = "cidr-block"
    values = ["${lookup(var.extra_public_subnets[count.index], "cidr")}"]
  }

  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.vpc.id}"]
  }
}

data "aws_security_group" "ecs_security_group" {
  filter {
    name   = "tag:Name"
    values = ["ecs-sg-${local.shared_infrastructure_name}-${var.environment}"]
  }
}

data "aws_security_group" "ecs_alb_security_group" {
  filter {
    name   = "tag:Name"
    values = ["alb-sg-${local.shared_infrastructure_name}-ecs-${var.environment}"]
  }
}

data "aws_acm_certificate" "infrastructure_root_domain_wildcard" {
  domain      = "*.${var.environment}.${local.shared_infrastructure_name}.${var.root_domain_zone}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_acm_certificate" "infrastructure_root_domain_wildcard_useast1" {
  provider    = "aws.useast1"
  domain      = "*.${var.environment}.${local.shared_infrastructure_name}.${var.root_domain_zone}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "infrastructure_root_domain_zone" {
  name = "${var.environment}.${local.shared_infrastructure_name}.${var.root_domain_zone}."
}

data "aws_route53_zone" "infrastructure_internal_domain_zone" {
  name   = "${var.environment}.${local.shared_infrastructure_name}.${var.internal_domain_zone}."
  vpc_id = "${data.aws_vpc.vpc.id}"
}

data "aws_eip" "nat_eip" {
  filter {
    name   = "tag:Name"
    values = ["${local.shared_infrastructure_name}-ecs-${var.environment}-nat-eip"]
  }
}

locals {
  ssm_parameters_command = [
    "curl",
    "-L",
    "https://github.com/Droplr/aws-env/raw/b215a696d96a5d651cf21a59c27132282d463473/bin/aws-env-linux-amd64",
    "-o",
    "aws-env",
    "&&",
    "chmod",
    "+x",
    "aws-env",
    "&&",
    "eval",
    "$(AWS_ENV_PATH=/${terraform.workspace}/$SSM_PATH_SUFFIX/ AWS_REGION=${var.region} ./aws-env)",
    "&&",
  ]

  install_postgres_cert_command = [
    "mkdir",
    "~/.postgresql",
    "&&",
    "curl",
    "-L",
    "https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem",
    "-o",
    "~/.postgresql/root.crt",
    "&&",
  ]

  private_subnet_ids = [
    "${concat(data.aws_subnet.ecs_private.*.id, data.aws_subnet.extra_private.*.id)}",
  ]

  public_subnet_ids = [
    "${concat(data.aws_subnet.ecs_public.*.id, data.aws_subnet.extra_public.*.id)}",
  ]

  private_route_table_id = "${data.aws_route_table.private_subnet_route_table.id}"
}

variable "region" {
  description = "AWS Region"
}

variable "infrastructure_name" {
  description = "Infrastructure Name"
}

variable "account_id" {
  description = "AWS Account ID"
  default     = ""
}

variable "dalmatian_role" {
  description = "Dalmatian role to assume"
  default     = "dalmatian-read"
}

variable "root_domain_zone" {
  description = "root domain Hosted zone to create in Route 53"
}

variable "internal_domain_zone" {
  description = "internal domain Hosted zone to create in Route 53"
}

variable "cidr" {
  description = "CIDR block"
}

variable "ecs_private_subnets" {
  description = "ECS Private subnets"
  type        = "list"
  default     = []
}

variable "extra_private_subnets" {
  description = "Extra Private subnets"
  type        = "list"
  default     = []
}

variable "ecs_public_subnets" {
  description = "ECS Public subnets"
  type        = "list"
  default     = []
}

variable "extra_public_subnets" {
  description = "Extra Public subnets"
  type        = "list"
  default     = []
}

variable "cluster_name" {
  description = "Cluster name"
  default     = ""
}

variable "environment" {
  description = "Environment"
}

variable "track_revision" {
  description = "Revision to track"
}
