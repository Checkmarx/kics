#this is a problematic code where the query should report a result(s)
resource "aws_cloudtrail" "multiRegionTypePositive_1" {
  name                          = "cloudtrail-multiregion-positive_1"
  s3_bucket_name                = "s3-logs"
}

resource "aws_cloudtrail" "multiRegionTypePositive_2" {
  name                          = "cloudtrail-multiregion-positive_2"
  s3_bucket_name                = "s3-logs"
  is_multi_region_trail = false
}