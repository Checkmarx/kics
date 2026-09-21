resource "aws_s3_bucket" "public_bucket" {
  bucket = "test-bucket-public-policy"
}

resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket                  = aws_s3_bucket.public_bucket.id
  block_public_policy     = false
}