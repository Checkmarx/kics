resource "alicloud_oss_bucket" "bucket-acl1" {
  bucket = "bucket-1-acl"
  acl    = "private"
}
