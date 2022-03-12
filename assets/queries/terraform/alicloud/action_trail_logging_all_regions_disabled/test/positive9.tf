resource "alicloud_actiontrail_trail" "actiontrail10" {
  trail_name         = "action-trail"
  oss_write_role_arn = "acs:ram::1182725xxxxxxxxxxx"
  trail_region       = "All"
}
