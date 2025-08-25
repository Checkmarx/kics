resource "aws_rds_cluster" "example_postgres" {
  cluster_identifier = "example-postgres-cluster"

  engine         = "postgres"

  master_username = "dbadmin"
  master_password = "StrongPassword123!"

  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  skip_final_snapshot = true
}
