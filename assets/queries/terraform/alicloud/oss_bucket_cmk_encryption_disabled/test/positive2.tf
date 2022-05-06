resource "alicloud_oss_bucket" "bucket_cmk_encryption3" {
  bucket = "bucket-170309-sserule"
  acl    = "private"
}
