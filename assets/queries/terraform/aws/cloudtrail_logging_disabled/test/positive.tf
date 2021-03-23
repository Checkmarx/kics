#this is a problematic code where the query should report a result(s)
resource "aws_cloudtrail" "positive1" {
  name                          = "positive"
  s3_bucket_name                = "bucketlog"
  enable_logging                = false
}