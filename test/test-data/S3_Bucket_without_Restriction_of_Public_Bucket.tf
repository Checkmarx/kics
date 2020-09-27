resource "aws_s3_bucket" "example" {
  bucket = "example"
}

// comment
resource "aws_s3_bucket_public_access_block" "example_exists" {
  bucket = aws_s3_bucket.example.id

  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "example_without" {
  bucket = aws_s3_bucket.example.id

  block_public_acls   = true
  block_public_policy = true
}