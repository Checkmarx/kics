resource "nifcloud_db_instance" "positive1" {
  identifier          = "example"
  instance_class      = "db.large8"
  publicly_accessible = true
}
