resource "aws_cloudfront_distribution" "positive1" {
  origin {
    domain_name = aws_s3_bucket.b.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    }
  }

  enabled             = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    #settings
  }

  restrictions {
    #restrictions
  }
}

resource "aws_cloudfront_distribution" "positive2" {
  origin {
    domain_name = aws_s3_bucket.b.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    }
  }

  enabled             = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    #settings
  }

  restrictions {
    #restrictions
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    minimum_protocol_version = "TLSv1_2016"
  }
}

resource "aws_cloudfront_distribution" "positive3" {
  origin {
    domain_name = aws_s3_bucket.b.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    }
  }

  enabled             = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    #settings
  }

  restrictions {
    #restrictions
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    minimum_protocol_version = "SSLv3"
  }
}

resource "aws_cloudfront_distribution" "positive4" {
  origin {
    domain_name = aws_s3_bucket.b.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    }
  }

  enabled             = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    #settings
  }

  restrictions {
    #restrictions
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    minimum_protocol_version = "TLSv1.1_2016"
  }
}

resource "aws_cloudfront_distribution" "positive5" {
  origin {
    domain_name = aws_s3_bucket.b.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    }
  }

  enabled             = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    #settings
  }

  restrictions {
    #restrictions
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
