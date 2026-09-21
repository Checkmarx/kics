provider "aws" {
  region = "us-east-1"
}

module "positive8_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  metadata_options {
    instance_metadata_tags = "enabled"
  }
}

module "positive8_launch_config" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 6.0"

  metadata_options {
    instance_metadata_tags = "enabled"
  }
}

