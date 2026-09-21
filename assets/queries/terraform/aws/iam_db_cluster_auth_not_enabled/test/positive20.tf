module "aurora_cluster" {
  source  = "terraform-aws-modules/rds/aws"
  version = "latest"

  identifier = "demodb"

  engine         = "postgres"
  skip_final_snapshot = true
}
