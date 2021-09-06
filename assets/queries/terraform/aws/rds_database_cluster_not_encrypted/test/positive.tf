resource "aws_db_cluster_snapshot" "positive" {
  db_cluster_identifier          = aws_rds_cluster.example.id
  db_cluster_snapshot_identifier = "resourcetestsnapshot1234"
  storage_encrypted = false
}
