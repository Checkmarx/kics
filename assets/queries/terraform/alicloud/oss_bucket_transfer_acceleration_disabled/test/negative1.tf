resource "alicloud_oss_bucket" "bucket-accelerate3" {
  bucket = "bucket_name"

  transfer_acceleration {
    enabled = true
  }
}
