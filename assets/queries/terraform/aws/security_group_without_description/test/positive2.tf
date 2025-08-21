module "positive2_1" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "positive2_1"
  vpc_id      = "vpc-12345678"

}


module "positive2_2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "positive2_2"
  description = null
  vpc_id      = "vpc-12345678"

}
