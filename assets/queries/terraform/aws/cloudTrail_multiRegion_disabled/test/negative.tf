#this code is a correct code for which the query should not find any result
resource "aws_cloudtrail" "multiRegionTypeNegative" {
  name                          = "cloudtrail-multiregion-negative"
  s3_bucket_name                = "s3-logs"
  is_multi_region_trail = true
}