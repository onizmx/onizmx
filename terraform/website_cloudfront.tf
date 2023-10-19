locals {
  s3_origin_id_root = "s3-${var.domain}"
  s3_origin_id_www  = "s3-www.${var.domain}"
}

resource "aws_cloudfront_distribution" "website_root" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = [var.domain]
  default_cache_behavior {
    target_origin_id       = local.s3_origin_id_root
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "all"
      }
    }
  }
  origin {
    origin_id   = local.s3_origin_id_root
    domain_name = aws_s3_bucket.website_root.bucket_regional_domain_name
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.website.arn
    ssl_support_method  = "sni-only"
  }
  custom_error_response {
    error_code            = 403
    error_caching_min_ttl = 86400
    response_page_path    = "/index.html"
    response_code         = 200
  }
  custom_error_response {
    error_code            = 404
    error_caching_min_ttl = 86400
    response_page_path    = "/index.html"
    response_code         = 200
  }
}

resource "aws_cloudfront_distribution" "website_www" {
  enabled         = true
  is_ipv6_enabled = true
  aliases         = ["www.${var.domain}"]
  default_cache_behavior {
    target_origin_id       = local.s3_origin_id_www
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "all"
      }
    }
  }
  origin {
    origin_id   = local.s3_origin_id_www
    domain_name = aws_s3_bucket.website_www.website_endpoint
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.website.arn
    ssl_support_method  = "sni-only"
  }
  custom_error_response {
    error_code            = 403
    error_caching_min_ttl = 86400
    response_page_path    = "/"
    response_code         = 200
  }
  custom_error_response {
    error_code            = 404
    error_caching_min_ttl = 86400
    response_page_path    = "/"
    response_code         = 200
  }
}
