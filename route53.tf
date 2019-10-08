resource "aws_route53_record" "alb" {
  zone_id = "${data.aws_route53_zone.infrastructure_root_domain_zone.zone_id}"
  name    = "alb.${local.infrastructure_domain_name}"
  type    = "CNAME"
  ttl     = "3600"

  records = [
    "${module.ecs-service.lb_dns_name}",
  ]
}

resource "aws_route53_record" "cloudfront" {
  zone_id = "${data.aws_route53_zone.infrastructure_root_domain_zone.zone_id}"
  name    = "${local.app_domain_name}"
  type    = "CNAME"
  ttl     = "3600"

  records = [
    "${aws_cloudfront_distribution.app.domain_name}",
  ]
}

resource "aws_route53_record" "ssl_verification" {
  zone_id = "${data.aws_route53_zone.infrastructure_root_domain_zone.zone_id}"
  name    = "${aws_acm_certificate.lb_certificate.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.lb_certificate.domain_validation_options.0.resource_record_type}"
  ttl     = "86400"

  records = [
    "${aws_acm_certificate.lb_certificate.domain_validation_options.0.resource_record_value}",
  ]
}
