resource "nifcloud_db_instance" "positive" {
  identifier     = "example"
  instance_class = "db.large8"
  network_id     = "net-COMMON_PRIVATE"
}
