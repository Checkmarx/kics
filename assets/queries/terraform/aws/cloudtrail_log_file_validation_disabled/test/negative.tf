resource "aws_cloudtrail" "negative1" {
  name                          = "negative1"
  s3_bucket_name                = "bucketlog1"
  enable_log_file_validation    = true
}
