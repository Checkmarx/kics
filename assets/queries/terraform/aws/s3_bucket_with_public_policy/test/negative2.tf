// `aws_s3_account_public_access_block` is NOT defined
// bucket resource is defined and sets `block_public_policy` to `false`
resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket = aws_s3_bucket.public_bucket.id
  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}
