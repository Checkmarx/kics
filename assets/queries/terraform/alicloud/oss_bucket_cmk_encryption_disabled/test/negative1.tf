resource "alicloud_oss_bucket" "bucket_cmk_encryption1" {
  bucket = "bucket-170309-sserule"
  acl    = "private"

  server_side_encryption_rule {
    sse_algorithm     = "KMS"
    kms_master_key_id = "your kms key id"
  }
}
