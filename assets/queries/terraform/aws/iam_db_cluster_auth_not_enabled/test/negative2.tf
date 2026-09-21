resource "aws_rds_cluster" "negative1" {
  cluster_identifier = "example-cluster"

  engine         = "mariadb"
  engine_version = "10.5"

  master_username = "username"
  master_password = "password123!"

  iam_database_authentication_enabled = false

  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  skip_final_snapshot = true
}
