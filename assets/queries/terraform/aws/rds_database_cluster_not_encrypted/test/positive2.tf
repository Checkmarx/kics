resource "aws_db_cluster_snapshot" "positive2" {
  db_cluster_identifier          = aws_rds_cluster.example3.id 
  db_cluster_snapshot_identifier = "resourcetestsnapshot1234"
}

resource "aws_rds_cluster" "example3" {
  cluster_identifier   = "example"
  db_subnet_group_name = aws_db_subnet_group.example.name
  engine_mode          = "multimaster"
  master_password      = "barbarbarbar"
  master_username      = "foo"
  skip_final_snapshot  = true
  storage_encrypted    = false
}
