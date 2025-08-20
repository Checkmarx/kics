resource "aws_rds_cluster" "positive3" {
  cluster_identifier = "mysql-no-version"
  engine             = "mysql"

  master_username = "user"
  master_password = "pass1234!"

  # intentionally omit iam_database_authentication_enabled
  skip_final_snapshot = true
}
