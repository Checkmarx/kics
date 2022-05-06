resource "alicloud_oss_bucket" "bucket_public_access_enabled1" {
  bucket = "bucket-170309-acl"
  acl    = "private"
}
