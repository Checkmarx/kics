resource "aws_db_snapshot" "private_snapshot" {
  db_snapshot_identifier = "private-db-snapshot"
  db_instance_identifier = "my-db-instance"
}
