resource "nifcloud_db_instance" "negative" {
  identifier              = "example"
  instance_class          = "db.large8"
  backup_retention_period = 7
}
