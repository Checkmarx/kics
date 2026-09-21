module "aurora_cluster" {
  source  = "terraform-aws-modules/rds/aws"
  version = "latest"

  identifier = "demodb"

  engine         = "unsupported_engine"
  engine_version = "10.0"

  iam_database_authentication_enabled = false

  skip_final_snapshot = true
}
