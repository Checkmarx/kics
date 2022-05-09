resource "alicloud_oss_bucket" "bucket_public_access_enabled3" {
  bucket = "bucket-170309-acl"
  acl    = "public-read-write"
}

resource "alicloud_oss_bucket" "bucket-logging" {
  bucket = "bucket-170309-logging"

  logging {
    target_bucket = alicloud_oss_bucket.bucket-target.id
    target_prefix = "log/"
  }
}
