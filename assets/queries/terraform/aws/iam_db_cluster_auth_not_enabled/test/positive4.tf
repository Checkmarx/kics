resource "aws_rds_cluster" "positive4" {
  cluster_identifier = "mysql-no-version"
  engine             = "mysql"

  master_username = "user"
  master_password = "pass1234!"

  iam_database_authentication_enabled = false
  skip_final_snapshot = true
}
