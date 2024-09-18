provider "aws" {
  region = "us-east-1"
}

locals {
  s3_prefix_list_cidr_block = "3.218.183.128/25"
}
resource "aws_vpc" "main" {
  cidr_block = "192.168.100.0/24"
  enable_dns_support = true
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "192.168.100.128/25"

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rtb"
  }
}

resource "aws_vpc_endpoint" "dynamodb-vpce-gw" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.dynamodb"
}

resource "aws_network_acl" "allow-public-outbound-nacl" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [aws_subnet.private-subnet.id]

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = local.s3_prefix_list_cidr_block
    from_port  = 443
    to_port    = 443
  }

  tags = {
    Name = "allow-public-outbound-nacl"
  }
}

resource "aws_security_group" "allow-public-outbound-sg" {
  name        = "allow-public-outbound-sg"
  description = "Allow HTTPS outbound traffic"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.s3_prefix_list_cidr_block]
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

resource "aws_instance" "test" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow-public-outbound-sg.id]
  subnet_id = aws_subnet.private-subnet.id
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "GameScores"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }
}
