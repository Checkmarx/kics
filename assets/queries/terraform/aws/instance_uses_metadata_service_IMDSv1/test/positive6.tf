provider "aws" {
  region = "us-east-1"
}

module "positive6_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  metadata_options {
    http_tokens   = "optional"
  }
}

module "positive6_launch_config" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 6.0"

  metadata_options {
    http_tokens   = "optional"
  }
}

