module "negative2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "negative2"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "vpc-12345678"

}