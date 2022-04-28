resource "alicloud_oss_bucket" "bucket_logging1" {
  bucket = "bucket-170309-logging"
  logging_isenable = false

  logging {
    target_bucket = alicloud_oss_bucket.bucket-target.id
    target_prefix = "log/"
  }
}
