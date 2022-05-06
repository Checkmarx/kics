resource "alicloud_oss_bucket" "bucket_public_access_enabled2" {
  bucket = "bucket-170309-acl"
  acl    = "public-read"
}
