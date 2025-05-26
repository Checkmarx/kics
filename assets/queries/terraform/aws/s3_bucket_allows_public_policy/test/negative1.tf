// account is defined, and explicit
// set `block_public_policy` to `true`
resource "aws_s3_account_public_access_block" "allow_public" {
  account_id      = 250924516109
  block_public_policy = true
}

// bucket resource is defined and sets `block_public_policy` to `false`
resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket = aws_s3_bucket.public_bucket.id
  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}
