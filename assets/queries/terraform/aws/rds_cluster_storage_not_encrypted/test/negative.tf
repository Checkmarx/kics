resource "aws_rds_cluster" "example1" {
cluster_identifier = "example"
db_subnet_group_name = aws_db_subnet_group.example.name
engine_mode = "multimaster"
master_password = "barbarbarbar"
master_username = "foo"
skip_final_snapshot = true
}