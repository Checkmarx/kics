resource "alicloud_oss_bucket" "bucket_actiontrail3" {
  bucket = "bucket_actiontrail_3"
  acl    = "public-read"
}

resource "alicloud_actiontrail_trail" "actiontrail3" {
  trail_name         = "action-trail"
  oss_write_role_arn = "acs:ram::1182725xxxxxxxxxxx"
  oss_bucket_name    = "bucket_actiontrail_3"
  event_rw           = "All"
  trail_region       = "All"
}

