resource "aws_rds_cluster" "positive1" {
  cluster_identifier   = "example"
  db_subnet_group_name = aws_db_subnet_group.example.name
  engine_mode          = ""
  master_password      = "barbarbarbar"
  master_username      = "foo"
  skip_final_snapshot  = true
}
resource "aws_rds_cluster" "positive2" {
  cluster_identifier   = "example"
  db_subnet_group_name = aws_db_subnet_group.example.name
  engine_mode          = "multimaster"
  master_password      = "barbarbarbar"
  master_username      = "foo"
  skip_final_snapshot  = true
  kms_key_id           = false
}