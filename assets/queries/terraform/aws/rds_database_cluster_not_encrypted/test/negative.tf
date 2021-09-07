resource "aws_db_cluster_snapshot" "negative" {
  db_cluster_identifier          = "development_cluster"
  db_cluster_snapshot_identifier = "resourcetestsnapshot1234"
  storage_encrypted = true
}
