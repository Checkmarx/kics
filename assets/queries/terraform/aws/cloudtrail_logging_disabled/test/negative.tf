resource "aws_cloudtrail" "negative_1" {
  name                          = "negative_1"
  s3_bucket_name                = "bucketlog"
  enable_logging                = true
}

resource "aws_cloudtrail" "negative_2" {
  name                          = "negative_2"
  s3_bucket_name                = "bucketlog"
}