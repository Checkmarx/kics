resource "aws_alb" "disabled_1" {
  internal           = false
  load_balancer_type = "application"
  name               = "alb"
  subnets            = module.vpc.public_subnets
}

resource "aws_alb" "disabled_2" {
  internal           = false
  load_balancer_type = "application"
  name               = "alb"
  subnets            = module.vpc.public_subnets

  drop_invalid_header_fields = false
}
