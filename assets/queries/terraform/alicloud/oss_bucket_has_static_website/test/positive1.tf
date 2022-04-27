resource "alicloud_oss_bucket" "bucket-website1" {
  bucket = "bucket-1-website"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
