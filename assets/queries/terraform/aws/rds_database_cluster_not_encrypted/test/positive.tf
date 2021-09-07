resource "aws_db_cluster_snapshot" "positive" {
  db_cluster_identifier          = "development_cluster"
  db_cluster_snapshot_identifier = "resourcetestsnapshot1234"
  storage_encrypted = false
}
