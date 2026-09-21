module "positive2-1" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "positive2-1"
  vpc_id      = "vpc-12345678"

}

module "positive2-2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "positive2-2"
  description = null
  vpc_id      = "vpc-12345678"

}