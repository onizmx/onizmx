resource "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_route53_record" "main" {
  for_each = {
    for dvo in aws_acm_certificate.website.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  zone_id         = aws_route53_zone.main.zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  allow_overwrite = true
  ttl             = 60
}

resource "aws_route53_record" "api_a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = aws_apigatewayv2_domain_name.api.domain_name
  type    = "A"
  alias {
    zone_id                = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].hosted_zone_id
    name                   = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website_root_a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "A"
  alias {
    zone_id                = aws_cloudfront_distribution.website_root.hosted_zone_id
    name                   = aws_cloudfront_distribution.website_root.domain_name
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website_www_a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain}"
  type    = "A"
  alias {
    zone_id                = aws_cloudfront_distribution.website_www.hosted_zone_id
    name                   = aws_cloudfront_distribution.website_www.domain_name
    evaluate_target_health = false
  }
}
