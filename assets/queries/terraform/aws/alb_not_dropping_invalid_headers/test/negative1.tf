resource "aws_alb" "enabled" {
  internal           = false
  load_balancer_type = "application"
  name               = "alb"
  subnets            = module.vpc.public_subnets

  drop_invalid_header_fields = true
}
