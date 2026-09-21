module "aurora_cluster" {
  source  = "terraform-aws-modules/rds/aws"
  version = "latest"

  identifier = "demodb"

  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.05.2"

  iam_database_authentication_enabled = false

  skip_final_snapshot = true
}
