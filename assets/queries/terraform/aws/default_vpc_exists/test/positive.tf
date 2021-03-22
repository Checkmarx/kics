resource "aws_vpc" "positive1" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  default          = true

  tags = {
    Name = "main"
  }
}

resource "aws_default_vpc" "positive2" {
  tags = {
    Name = "Default VPC"
  }
}