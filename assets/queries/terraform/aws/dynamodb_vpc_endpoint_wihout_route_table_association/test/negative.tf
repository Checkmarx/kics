provider "aws" {
  region = "us-east-1"
}

locals {
  s3_prefix_list_cidr_block = "3.218.183.128/25"
}
resource "aws_vpc" "main2" {
  cidr_block = "192.168.100.0/24"
  enable_dns_support = true
}

resource "aws_subnet" "private-subnet2" {
  vpc_id     = aws_vpc.main2.id
  cidr_block = "192.168.100.128/25"

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_route_table" "private-rtb2" {
  vpc_id = aws_vpc.main2.id

  tags = {
    Name = "private-rtb"
  }
}

resource "aws_route_table_association" "private-rtb-assoc2" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.private-rtb2.id
}

resource "aws_vpc_endpoint" "dynamodb-vpce-gw2" {
  vpc_id       = aws_vpc.main2.id
  service_name = "com.amazonaws.us-east-1.dynamodb"
}

resource "aws_network_acl" "allow-public-outbound-nacl2" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [aws_subnet.private-subnet2.id]

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

resource "aws_security_group" "allow-public-outbound-sg2" {
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

data "aws_ami" "ubuntu2" {
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

resource "aws_instance" "test2" {
  ami = data.aws_ami.ubuntu2.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow-public-outbound-sg2.id]
  subnet_id = aws_subnet.private-subnet2.id
}

resource "aws_dynamodb_table" "basic-dynamodb-table2" {
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
