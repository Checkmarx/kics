resource "alicloud_oss_bucket" "bucket_actiontrail2" {
  bucket = "bucket_actiontrail_2"
}

resource "alicloud_actiontrail_trail" "actiontrail2" {
  trail_name         = "action-trail"
  oss_write_role_arn = "acs:ram::1182725xxxxxxxxxxx"
  oss_bucket_name    = "bucket_actiontrail_2"
  event_rw           = "All"
  trail_region       = "All"
}
