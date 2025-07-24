// account is defined, and explicit
// set `restrict_public_buckets` to `true`
resource "aws_s3_account_public_access_block" "restrict_public" {
  account_id      = 250924516109
  restrict_public_buckets = true
}

// bucket resource is defined and sets `restrict_public_buckets` to `false`
resource "aws_s3_bucket_public_access_block" "restrict_public" {
  bucket = aws_s3_bucket.public_bucket.id
  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}
