module "rds_cluster" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  identifier             = "my-rds-cluster"
  engine                 = "aurora-mysql"
  engine_mode            = "provisioned"
  skip_final_snapshot    = true
}
