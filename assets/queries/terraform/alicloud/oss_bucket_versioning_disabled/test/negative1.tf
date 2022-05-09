resource "alicloud_oss_bucket" "bucket-versioning1" {
  bucket = "bucket-170309-versioning"
  acl    = "private"

  versioning {
    status = "Enabled"
  }
}
