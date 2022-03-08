resource "alicloud_oss_bucket" "oss_bucket_lifecycle_enabled3" {
  bucket = "bucket-170309-versioning"
  acl    = "private"

  versioning {
    status = "Enabled"
  }
}
