resource "aws_cloudtrail" "positive1" {
  name                          = "positive1"
  s3_bucket_name                = "bucketlog1"
}

resource "aws_cloudtrail" "positive2" {
  name                          = "positive2"
  s3_bucket_name                = "bucketlog2"
  enable_log_file_validation    = false
}
