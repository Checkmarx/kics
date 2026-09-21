module "aurora_cluster" {
  source  = "terraform-aws-modules/rds/aws"
  version = "latest"

  identifier = "demodb"

  engine         = "postgres"
  engine_version = "15.5"

  iam_database_authentication_enabled = true

  skip_final_snapshot = true
}
