resource "aws_cloudtrail" "positive3" {
  name                          = "npositive_3"
  s3_bucket_name                = "bucketlog_3"
  is_multi_region_trail         = true
  include_global_service_events = false
}
