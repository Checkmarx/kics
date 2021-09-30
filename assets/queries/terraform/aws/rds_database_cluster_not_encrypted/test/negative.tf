resource "aws_db_cluster_snapshot" "negative" {
  db_cluster_identifier          = aws_rds_cluster.example.id 
  db_cluster_snapshot_identifier = "resourcetestsnapshot1234"
}

resource "aws_rds_cluster" "example" {
  cluster_identifier   = "example"
  db_subnet_group_name = aws_db_subnet_group.example.name
  engine_mode          = "multimaster"
  master_password      = "barbarbarbar"
  master_username      = "foo"
  skip_final_snapshot  = true
  storage_encrypted    = true
}
