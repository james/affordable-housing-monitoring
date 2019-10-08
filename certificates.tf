resource "aws_acm_certificate" "lb_certificate" {
  domain_name               = "${local.app_domain_name}"
  validation_method         = "DNS"
  subject_alternative_names = "${var.additional_domains}"

  lifecycle {
    create_before_destroy = true
    # https://github.com/terraform-providers/terraform-provider-aws/issues/8531
    # this will need removing if we do want to make changes
    ignore_changes = ["subject_alternative_names"]
  }
}

resource "aws_acm_certificate" "cloudfront_certificate" {
  provider                  = "aws.useast1"
  domain_name               = "${local.app_domain_name}"
  validation_method         = "DNS"
  subject_alternative_names = "${var.additional_domains}"

  lifecycle {
    create_before_destroy = true
    # https://github.com/terraform-providers/terraform-provider-aws/issues/8531
    # this will need removing if we do want to make changes
    ignore_changes = ["subject_alternative_names"]
  }
}
