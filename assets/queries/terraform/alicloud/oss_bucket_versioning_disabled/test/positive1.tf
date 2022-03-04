resource "alicloud_oss_bucket" "bucket-versioning" {
  bucket = "bucket-170309-versioning"
  acl    = "private"

  versioning {
    status = "Disabled"
  }
}
