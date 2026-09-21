provider "aws" {
  region = "us-east-1"
}

module "positive9_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  image_id      = "ami-12345678"
  instance_type = "t2.micro"
}

module "positive9_launch_config" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 6.0"

  image_id      = "ami-12345678"
  instance_type = "t2.micro"
}

