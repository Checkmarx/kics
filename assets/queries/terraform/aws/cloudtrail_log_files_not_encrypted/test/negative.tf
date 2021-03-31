resource "aws_cloudtrail" "negative1" {
  name                          = "negative1"
  s3_bucket_name                = "bucketlog1"
  kms_key_id                    = "arn:aws:kms:us-east-2:123456789012:key/12345678-1234-1234-1234-123456789012"
}
