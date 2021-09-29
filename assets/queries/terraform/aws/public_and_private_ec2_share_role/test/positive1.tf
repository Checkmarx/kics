provider "aws" {
  region = "us-east-1"
}

locals {
  test_description = "two EC2s, one public, one private"
  test_name        = "Ec2RoleShareRule test - use case 1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name = "Ec2RoleShareRule1"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  cidr = "10.0.0.0/16"
  manage_default_security_group= true
  default_security_group_ingress = [
          {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "0.0.0.0/0"
    }]
  default_security_group_egress =[]
  version = "3.7.0"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = "aws_iam_role.test_role.name"
}


resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = "aws_iam_role.test_role.id"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_instance" "pub_ins" {
  ami           = "data.aws_ami.ubuntu.id"
  instance_type = "t2.micro"
  subnet_id = module.vpc.public_subnets[0]
  iam_instance_profile = aws_iam_instance_profile.test_profile.name

}

resource "aws_instance" "priv_ins" {
  ami           = "data.aws_ami.ubuntu.id"
  instance_type = "t2.micro"
  subnet_id = module.vpc.private_subnets[0]
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
}
