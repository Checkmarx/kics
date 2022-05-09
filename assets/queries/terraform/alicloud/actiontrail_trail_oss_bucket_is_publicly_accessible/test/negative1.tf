resource "alicloud_oss_bucket" "bucket_actiontrail1" {
  bucket = "bucket_actiontrail_1"
  acl    = "private"
}

resource "alicloud_actiontrail_trail" "actiontrail1" {
  trail_name         = "action-trail"
  oss_write_role_arn = "acs:ram::1182725xxxxxxxxxxx"
  oss_bucket_name    = "bucket_actiontrail_1"
  event_rw           = "All"
  trail_region       = "All"
}
