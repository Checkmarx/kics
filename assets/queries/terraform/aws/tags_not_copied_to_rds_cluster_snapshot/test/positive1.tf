resource "aws_rds_cluster" "example" {
  engine               = "aurora-mysql"
  cluster_identifier   = "my-rds-cluster"
  master_username      = "admin"
  master_password      = "YourSecretPassword"
  skip_final_snapshot  = true

  copy_tags_to_snapshot = false
}