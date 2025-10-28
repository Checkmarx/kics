# Cases that should NOT be flagged by the improved rule - legitimate public buckets

# Website bucket with clear naming pattern
resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-company-website-assets"
}

resource "aws_s3_bucket_public_access_block" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  # Intentionally allowing public policy for website
  # block_public_policy = false (default)
}

resource "aws_s3_bucket_website_configuration" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Static assets bucket with CloudFront
resource "aws_s3_bucket" "static_assets" {
  bucket = "my-app-static-content"
}

resource "aws_s3_bucket_public_access_block" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id
  # Allowing public policy for CloudFront access
}

resource "aws_cloudfront_distribution" "static_assets" {
  origin {
    domain_name = aws_s3_bucket.static_assets.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.static_assets.id}"
  }

  enabled = true
  default_cache_behavior {
    target_origin_id = "S3-${aws_s3_bucket.static_assets.id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# CDN bucket with CORS configuration
resource "aws_s3_bucket" "cdn_bucket" {
  bucket = "my-cdn-assets"
}

resource "aws_s3_bucket_public_access_block" "cdn_bucket" {
  bucket = aws_s3_bucket.cdn_bucket.id
  # Public policy needed for CDN
}

resource "aws_s3_bucket_cors_configuration" "cdn_bucket" {
  bucket = aws_s3_bucket.cdn_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

# Media bucket with public naming pattern
resource "aws_s3_bucket" "media_files" {
  bucket = "company-public-media"
}

resource "aws_s3_bucket_public_access_block" "media_files" {
  bucket = aws_s3_bucket.media_files.id
  # Public access needed for media serving
}

# Frontend assets bucket
resource "aws_s3_bucket" "frontend_assets" {
  bucket = "app-frontend-distribution"
}

resource "aws_s3_bucket_public_access_block" "frontend_assets" {
  bucket = aws_s3_bucket.frontend_assets.id
  # Public policy for frontend asset serving
}

# Backup bucket with public naming (logs/backup pattern)
resource "aws_s3_bucket" "public_logs" {
  bucket = "company-public-logs-backup"
}

resource "aws_s3_bucket_public_access_block" "public_logs" {
  bucket = aws_s3_bucket.public_logs.id
  # Public access for log aggregation services
}

# Images bucket with website configuration
resource "aws_s3_bucket" "image_hosting" {
  bucket = "my-images-hosting"
}

resource "aws_s3_bucket_public_access_block" "image_hosting" {
  bucket = aws_s3_bucket.image_hosting.id
  # Public policy for image hosting
}

resource "aws_s3_bucket_website_configuration" "image_hosting" {
  bucket = aws_s3_bucket.image_hosting.id

  index_document {
    suffix = "index.html"
  }
}
