resource "alicloud_oss_bucket" "bucket_logging2" {
  bucket = "bucket-170309-acl"
  acl    = "public-read"
}
