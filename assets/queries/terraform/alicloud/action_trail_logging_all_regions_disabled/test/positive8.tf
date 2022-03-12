resource "alicloud_actiontrail_trail" "actiontrail9" {
  trail_name         = "action-trail"
  oss_write_role_arn = "acs:ram::1182725xxxxxxxxxxx"
  oss_bucket_name    = "bucket_name"
  trail_region       = "All"
}
