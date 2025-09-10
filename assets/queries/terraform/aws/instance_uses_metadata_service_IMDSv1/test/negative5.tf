provider "aws" {
  region = "us-east-1"
}

module "negative5_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  metadata_options {
    http_tokens   = "required"
  }
}

module "negative5_launch_config" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 6.0"

  metadata_options {
    http_tokens   = "required"
  }
}

