resource "nifcloud_db_instance" "positive" {
  identifier              = "example"
  instance_class          = "db.large8"
  backup_retention_period = 5
}
