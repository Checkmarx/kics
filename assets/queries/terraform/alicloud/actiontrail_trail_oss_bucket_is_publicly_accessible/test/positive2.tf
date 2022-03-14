resource "alicloud_oss_bucket" "bucket_actiontrail4" {
  bucket = "bucket_actiontrail_4"
  acl    = "public-read-write"
}

resource "alicloud_actiontrail_trail" "actiontrail4" {
  trail_name         = "action-trail"
  oss_write_role_arn = "acs:ram::1182725xxxxxxxxxxx"
  oss_bucket_name    = "bucket_actiontrail_4"
  event_rw           = "All"
  trail_region       = "All"
}
