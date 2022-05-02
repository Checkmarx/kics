resource "alicloud_log_project" "example2" {
  name        = "tf-log"
  description = "created by terraform"
}

resource "alicloud_log_store" "example2" {
  project               = alicloud_log_project.example.name
  name                  = "tf-log-store"
  shard_count           = 3
  auto_split            = true
  max_split_shard_count = 60
  append_meta           = true
}
