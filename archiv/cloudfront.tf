resource "aws_cloudfront_distribution" "visitors" {
  aliases = [var.urls["visitors"], "edge2cloud.nxp.com"]
  comment = "Distribution for ${var.project} ${var.environment} visitors frontend environment"

  enabled             = "true"
  http_version        = "http2"
  is_ipv6_enabled     = "true"
  price_class         = "PriceClass_All"
  retain_on_delete    = "false"
  default_root_object = "index.html"

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "403"
    response_code         = "403"
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "404"
    response_code         = "404"
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    cached_methods           = ["GET", "HEAD"]
    compress                 = "true"
    default_ttl              = "0"
    max_ttl                  = "0"
    min_ttl                  = "0"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
    smooth_streaming         = "false"
    target_origin_id         = "s3_origin_bucket"
    viewer_protocol_policy   = "redirect-to-https"
  }

  origin {
    connection_attempts = "3"
    connection_timeout  = "10"
    domain_name         = aws_s3_bucket.frontend_buckets[local.buckets[1]].bucket_regional_domain_name
    origin_id           = "s3_origin_bucket"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:034839930720:certificate/5950cdc6-81f2-4918-b0a1-d9d82dba8f5e"
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}

resource "aws_cloudfront_distribution" "admin" {
  aliases = [var.urls["admin"]]
  comment = "Distribution for ${var.project} ${var.environment} admin frontend environment"

  enabled             = "true"
  http_version        = "http2"
  is_ipv6_enabled     = "true"
  price_class         = "PriceClass_All"
  retain_on_delete    = "false"
  default_root_object = "index.html"

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "403"
    response_code         = "403"
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "404"
    response_code         = "404"
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    cached_methods           = ["GET", "HEAD"]
    compress                 = "true"
    default_ttl              = "0"
    max_ttl                  = "0"
    min_ttl                  = "0"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
    smooth_streaming         = "false"
    target_origin_id         = "s3_origin_bucket"
    viewer_protocol_policy   = "redirect-to-https"
  }

  origin {
    connection_attempts = "3"
    connection_timeout  = "10"
    domain_name         = aws_s3_bucket.frontend_buckets[local.buckets[0]].bucket_regional_domain_name
    origin_id           = "s3_origin_bucket"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = module.cloudfront_cert.acm_certificate_arn
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}
