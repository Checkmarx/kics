resource "aws_alb" "disabled_1" {
  internal           = false
  name               = "alb"
  subnets            = module.vpc.public_subnets
}

resource "aws_lb" "disabled_2" {
  internal           = false
  name               = "alb"
  subnets            = module.vpc.public_subnets

  drop_invalid_header_fields = false
}
