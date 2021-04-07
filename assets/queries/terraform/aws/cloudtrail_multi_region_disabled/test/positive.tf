#this is a problematic code where the query should report a result(s)
resource "aws_cloudtrail" "positive1" {
  name                          = "npositive_1"
  s3_bucket_name                = "bucketlog_1"
}

resource "aws_cloudtrail" "positive2" {
  name                          = "npositive_2"
  s3_bucket_name                = "bucketlog_2"
  is_multi_region_trail         = false
}
