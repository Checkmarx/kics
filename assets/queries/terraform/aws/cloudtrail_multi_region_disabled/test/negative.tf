#this code is a correct code for which the query should not find any result
resource "aws_cloudtrail" "negative1" {
  name                          = "negative"
  s3_bucket_name                = "bucketlog"
  is_multi_region_trail         = true
}
