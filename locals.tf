locals {
  app_name                   = "ahm"
  infrastructure_domain_name = "${var.infrastructure_name}.${var.environment}.${local.shared_infrastructure_name}.${var.root_domain_zone}"
  app_domain_name            = "affordable-housing-monitoring.${local.infrastructure_domain_name}"
  app_service_name           = "${local.app_name}-${var.environment}"
  app_github_owner           = "dxw"
  app_github_repo            = "affordable-housing-monitoring"
}
