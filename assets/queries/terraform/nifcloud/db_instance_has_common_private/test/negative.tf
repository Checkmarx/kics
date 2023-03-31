resource "nifcloud_db_instance" "negative" {
  identifier     = "example"
  instance_class = "db.large8"
  network_id     = nifcloud_private_lan.main.id
}
