resource "alicloud_oss_bucket" "bucket_cmk_encryption2" {
  bucket = "bucket-170309-sserule"
  acl    = "private"

  server_side_encryption_rule {
    sse_algorithm = "AES256"
  }
}
