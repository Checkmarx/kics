resource "aws_s3_account_public_access_block" "allow_public" {
  account_id      = 250924516109
}

resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket = aws_s3_bucket.public_bucket.id
  block_public_acls   = false
  block_public_policy = true
  ignore_public_acls  = false
  restrict_public_buckets = false
}
