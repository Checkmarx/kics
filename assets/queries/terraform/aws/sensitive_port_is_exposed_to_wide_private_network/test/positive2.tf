resource "aws_security_group" "positive" {
  name        = "shared_tls_group"
  description = "Security group with multiple ingress rules"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "positive1" {
  security_group_id = aws_security_group.positive.id
  cidr_ipv4         = "10.0.0.0/8"
  from_port         = 2200
  to_port           = 2500
  ip_protocol       = "-1"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "positive2" {
  security_group_id = aws_security_group.positive.id
  cidr_ipv4         = "192.168.0.0/16"
  from_port         = 20
  to_port           = 60
  ip_protocol       = "tcp"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "positive3" {
  security_group_id = aws_security_group.positive.id
  cidr_ipv4         = "172.16.0.0/12"
  from_port         = 5000
  to_port           = 6000
  ip_protocol       = "-1"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "positive4" {
  security_group_id = aws_security_group.positive.id
  cidr_ipv4         = "10.0.0.0/8"
  from_port         = 20
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "positive5a" {
  security_group_id = aws_security_group.positive.id
  cidr_ipv4         = "192.168.0.0/16"
  from_port         = 445
  to_port           = 500
  ip_protocol       = "udp"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "positive6a" {
  security_group_id = aws_security_group.positive.id
  cidr_ipv4         = "10.68.0.0"
  from_port         = 135
  to_port           = 170
  ip_protocol       = "udp"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "positive7a" {
  security_group_id = aws_security_group.positive.id
  cidr_ipv4         = "192.168.0.0/16"
  from_port         = 2383
  to_port           = 2383
  ip_protocol       = "udp"
  description       = "TLS from VPC"
}

