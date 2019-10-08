resource "aws_cloudfront_distribution" "app" {
  origin {
    domain_name = "alb.${local.infrastructure_domain_name}"
    origin_id   = "${terraform.workspace}-default-origin"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = "80"
      https_port             = "443"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled = true
  aliases = "${concat(list(local.app_domain_name), var.additional_domains)}"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${terraform.workspace}-default-origin"

    forwarded_values {
      query_string = true

      headers = [
        "*",
      ]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate.cloudfront_certificate.arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method       = "sni-only"
  }

  tags = {
    Name = "${terraform.workspace}"
  }
}
