module "efs" {
  source = "cloudposse/efs/aws"
  version = "0.31.1"
  namespace       = "eg"
  stage           = "test"
  name            = "app"
  region          = "us-west-1"
  vpc_id          = var.vpc_id
  subnets         = var.private_subnets
  security_groups = [var.security_group_id]
  zone_id         = var.aws_route53_dns_zone_id
}
