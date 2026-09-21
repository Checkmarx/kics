resource "aws_rds_cluster" "positive1" {
  cluster_identifier = "example-cluster"

  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.05.2"

  master_username = "username"
  master_password = "password123!"

  iam_database_authentication_enabled = false

  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  skip_final_snapshot = true
}