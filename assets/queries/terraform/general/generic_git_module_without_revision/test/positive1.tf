variable "cluster_name" {
  default     = "example"
  description = "cluster name"
  type        = string
}

module "acm" {
  source      = "git::https://example.com/vpc.git"
  version     = "~> v2.0"
  domain_name = var.site_domain
  zone_id     = data.aws_route53_zone.this.zone_id
  tags        = var.tags

  providers = {
    aws = aws.us_east_1 # cloudfront needs acm certificate to be from "us-east-1" region
  }
}

resource "aws_eks_cluster" "negative1" {
  depends_on                = [aws_cloudwatch_log_group.example]

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  name                      = var.cluster_name
}
