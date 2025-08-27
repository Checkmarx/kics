module "aurora_cluster" {
  source  = "terraform-aws-modules/rds/aws"
  version = "latest"

  identifier = "demodb"

  engine         = "mariadb"
  engine_version = "10.5"

  iam_database_authentication_enabled = false

  skip_final_snapshot = true
}
