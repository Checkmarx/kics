resource "aws_alb" "enabled" {
  internal           = false
  name               = "alb"
  subnets            = module.vpc.public_subnets

  drop_invalid_header_fields = true
}

resource "aws_lb" "enabled" {
  internal           = false
  name               = "alb"
  subnets            = module.vpc.public_subnets

  drop_invalid_header_fields = true
}
