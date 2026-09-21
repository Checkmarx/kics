resource "aws_rds_cluster" "negative7" {
  cluster_identifier = "example-cluster"
 
  engine         = "unsupported_engine"
  engine_version = "10.0"
 
  master_username = "username"
  master_password = "password123!"
 
  iam_database_authentication_enabled = false
 
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
 
  skip_final_snapshot = true
}