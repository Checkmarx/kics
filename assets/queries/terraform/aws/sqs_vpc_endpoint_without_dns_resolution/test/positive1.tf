locals {
  region = "us-east-1"
  cidr_block = "172.16.0.0/16"
  public_subnet_cidr_block = "172.16.100.0/24"
  quad_zero_cidr_block = "0.0.0.0/0"
}

provider "aws" {
  region = local.region
}

resource "aws_vpc" "main" {
  cidr_block = local.cidr_block
  enable_dns_support = false
  enable_dns_hostnames = false
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.public_subnet_cidr_block

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = local.cidr_block
    vpc_endpoint_id = aws_vpc_endpoint.sqs-vpc-endpoint.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rtb"
  }
}

resource "aws_route_table_association" "public-rtb-assoc" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_security_group" "public-internet-sg" {
  name        = "public-internet-sg"
  description = "Allow all local traffic with internet access"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.quad_zero_cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.cidr_block]
  }

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

resource "aws_instance" "test-ec2-instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.public-internet-sg.id]
}

resource "aws_vpc_endpoint" "sqs-vpc-endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${local.region}.sqs"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = [aws_subnet.public-subnet.id]
  security_group_ids = [aws_security_group.public-internet-sg.id]
}

resource "aws_sqs_queue" "test-queue" {
  name = "test-queue"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}
