resource "aws_cloudtrail" "negative1" {
  name                          = "negative_1"
  s3_bucket_name                = "bucketlog"
  enable_logging                = true
}

resource "aws_cloudtrail" "negative2" {
  name                          = "negative_2"
  s3_bucket_name                = "bucketlog"
}