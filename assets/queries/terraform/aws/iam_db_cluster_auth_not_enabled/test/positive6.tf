resource "aws_rds_cluster" "positive6" {
  cluster_identifier = "mariadb-with-version"
  engine             = "mariadb"
  engine_version     = "10.11"

  master_username = "user"
  master_password = "pass1234!"

  skip_final_snapshot = true
}
