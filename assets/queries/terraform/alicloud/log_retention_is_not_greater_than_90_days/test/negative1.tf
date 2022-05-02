resource "alicloud_log_project" "example1" {
  name        = "tf-log"
  description = "created by terraform"
}

resource "alicloud_log_store" "example1" {
  project               = alicloud_log_project.example.name
  name                  = "tf-log-store"
  retention_period      = 91
  shard_count           = 3
  auto_split            = true
  max_split_shard_count = 60
  append_meta           = true
}
