resource "aws_security_group" "base" {
  name        = "base_sg"
  description = "Base security group"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "negative1" {
  security_group_id = aws_security_group.base.id
  description        = "TLS from VPC"
  from_port          = 2383
  to_port            = 2383
  ip_protocol        = "tcp"
  cidr_ipv4          = aws_vpc.main.cidr_block
}

resource "aws_vpc_security_group_ingress_rule" "negative2" {
  security_group_id = aws_security_group.base.id
  description        = "TLS from VPC"
  from_port          = 2384
  to_port            = 2386
  ip_protocol        = "tcp"
  cidr_ipv4          = "/0"
}

resource "aws_vpc_security_group_ingress_rule" "negative3" {
  security_group_id = aws_security_group.base.id
  description        = "TLS from VPC"
  from_port          = 25
  to_port            = 2500
  ip_protocol        = "tcp"
  cidr_ipv4          = "1.2.3.4/0"
}

resource "aws_vpc_security_group_ingress_rule" "negative4" {
  security_group_id = aws_security_group.base.id
  description        = "TLS from VPC"
  from_port          = 25
  to_port            = 2500
  ip_protocol        = "tcp"
  cidr_ipv4          = "1.2.3.4/5"
}

resource "aws_vpc_security_group_ingress_rule" "negative5a" {
  security_group_id = aws_security_group.base.id
  description        = "TLS from VPC"
  from_port          = 25
  to_port            = 2500
  ip_protocol        = "udp"
  cidr_ipv4          = "1.2.3.4/5"
}

resource "aws_vpc_security_group_ingress_rule" "negative5b" {
  security_group_id = aws_security_group.base.id
  description        = "TLS from VPC"
  from_port          = 25
  to_port            = 2500
  ip_protocol        = "udp"
  cidr_ipv4          = "0.0.0.0/12"
}
