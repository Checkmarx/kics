resource "alicloud_oss_bucket" "bucket-accelerate" {
  bucket = "bucket_name"

  transfer_acceleration {
    enabled = false
  }
}
