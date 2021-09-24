resource "aws_s3_bucket" "positive1" {
  bucket = "example"
}

// comment
resource "aws_s3_bucket_public_access_block" "positive2" {
  bucket = aws_s3_bucket.example.id

  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "positive3" {
  bucket = aws_s3_bucket.example.id

  block_public_acls   = true
  block_public_policy = true
}