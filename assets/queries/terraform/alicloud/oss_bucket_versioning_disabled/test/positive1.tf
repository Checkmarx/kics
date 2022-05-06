resource "alicloud_oss_bucket" "bucket-versioning2" {
  bucket = "bucket-170309-versioning"
  acl    = "private"

  versioning {
    status = "Suspended"
  }
}
