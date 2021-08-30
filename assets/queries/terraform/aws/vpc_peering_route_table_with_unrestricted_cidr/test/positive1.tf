terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "<= 3.49.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable vpc_1_cidr_block {
  type        = string
  default     = "10.0.0.0/16"
  description = "vpc default CIDR block"
}

variable vpc_2_cidr_block {
  type        = string
  default     = "10.2.0.0/16"
  description = "vpc default CIDR block"
}

variable vpc_cidr_public_block {
  type        = string
  default     = "10.0.1.0/24"
  description = "public CIDR block"
}

variable vpc_cidr_private_block {
  type        = string
  default     = "10.0.2.0/24"
  description = "private CIDR block"
}

resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_1_cidr_block

  tags = {
    Name = "tf-test-vpc-1"
    Project = "CIS Certification"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.vpc_cidr_public_block
  availability_zone = "us-east-1a"

  tags = {
    Name    = "public-subnet-1"
    Project = "CIS Certification"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.vpc_cidr_private_block
  availability_zone = "us-east-1a"

  tags = {
    Name    = "private-subnet-1"
    Project = "CIS Certification"
  }
}

resource "aws_vpc" "vpc2" {
  cidr_block = var.vpc_2_cidr_block

  tags = {
    Name = "tf-test-vpc-2"
    Project = "CIS Certification"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id                  = aws_vpc.vpc1.id

  tags                    = {
    Name                  = "igw"
    Project               = "CIS Certification"
  }
}

resource "aws_eip" "nat" {}

resource "aws_nat_gateway" "nat" {
  allocation_id          = aws_eip.nat.id
  subnet_id              = aws_subnet.public.*.id[0]

  tags                   = {
    Name                 = "nat"
    Project              = "CIS Certification"
  }

  depends_on             = [aws_internet_gateway.igw]
}

data "aws_caller_identity" "current" {}

resource "aws_vpc_peering_connection" "my_peering" {
  peer_owner_id = data.aws_caller_identity.current.account_id
  peer_vpc_id   = aws_vpc.vpc1.id
  vpc_id        = aws_vpc.vpc2.id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between vpc1 and vpc2"
    Project = "CIS Certification"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block                  = "0.0.0.0/0"
    vpc_peering_connection_id   = aws_vpc_peering_connection.my_peering.id
  }

  tags = {
    Name = "public_route_table"
    Project = "CIS Certification"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block                  = aws_vpc.vpc2.cidr_block
    vpc_peering_connection_id   = aws_vpc_peering_connection.my_peering.id
  }

  tags = {
    Name = "private_route_table"
    Project = "CIS Certification"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_route_table.id
}
