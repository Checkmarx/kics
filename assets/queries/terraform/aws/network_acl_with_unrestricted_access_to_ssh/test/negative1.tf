provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_network_acl" "negative1" {
  vpc_id = aws_vpc.main.id

  egress = [
    {
      protocol   = "tcp"
      rule_no    = 200
      action     = "allow"
      cidr_block = "10.3.0.0/18"
      from_port  = 443
      to_port    = 443
    }
  ]

  ingress = [
    {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "10.3.0.0/18"
      from_port   = 22
      to_port     = 22
    }
  ]

  tags = {
    Name = "main"
  }
}
