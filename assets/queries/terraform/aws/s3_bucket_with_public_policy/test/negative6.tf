# These should NOT be flagged - intentional public buckets

# Website bucket with public name pattern
resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-website-bucket"
}

resource "aws_s3_bucket_public_access_block" "website_public" {
  bucket = aws_s3_bucket.website_bucket.id
  block_public_policy = false  # Should not be flagged - website bucket
}

# Static assets bucket with website configuration
resource "aws_s3_bucket" "static_assets" {
  bucket = "static-assets-cdn"
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_assets.id
  
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "static_public" {
  bucket = aws_s3_bucket.static_assets.id
  block_public_policy = false  # Should not be flagged - has website config
}

# CDN bucket with CloudFront integration
resource "aws_s3_bucket" "cdn_bucket" {
  bucket = "my-cdn-bucket"
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.cdn_bucket.bucket_domain_name
    origin_id   = "S3-${aws_s3_bucket.cdn_bucket.id}"
  }
  
  default_cache_behavior {
    target_origin_id = "S3-${aws_s3_bucket.cdn_bucket.id}"
    viewer_protocol_policy = "redirect-to-https"
    
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
  }
  
  enabled = true
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_s3_bucket_public_access_block" "cdn_public" {
  bucket = aws_s3_bucket.cdn_bucket.id
  block_public_policy = false  # Should not be flagged - CloudFront integration
}

# Bucket with CORS configuration
resource "aws_s3_bucket" "cors_bucket" {
  bucket = "my-cors-bucket"
}

resource "aws_s3_bucket_cors_configuration" "cors_config" {
  bucket = aws_s3_bucket.cors_bucket.id
  
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "cors_public" {
  bucket = aws_s3_bucket.cors_bucket.id
  block_public_policy = false  # Should not be flagged - has CORS config
}
