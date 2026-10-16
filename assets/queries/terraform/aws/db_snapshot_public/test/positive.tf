resource "aws_db_snapshot" "public_snapshot" {
  db_snapshot_identifier = "public-db-snapshot"
  db_instance_identifier = "my-db-instance"
  shared_accounts        = ["all"]
}
