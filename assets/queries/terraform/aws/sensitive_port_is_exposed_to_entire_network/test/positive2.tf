resource "aws_security_group" "positive" {
  name        = "allow_tls1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "positive1_ingress_rule" {
  security_group_id = aws_security_group.positive.id
  from_port         = 2200
  to_port           = 2500
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "positive2_ingress_rule" {
  security_group_id = aws_security_group.positive.id
  from_port         = 20
  to_port           = 60
  ip_protocol       = "tcp"
  cidr_ipv4         = "/0"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "positive3_ingress_rule" {
  security_group_id = aws_security_group.positive.id
  from_port         = 5000
  to_port           = 6000
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "positive4_ingress_rule" {
  security_group_id = aws_security_group.positive.id
  from_port         = 20
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "/0"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "positive5_ingress_2_rule" {
  security_group_id = aws_security_group.positive.id
  from_port         = 445
  to_port           = 500
  ip_protocol       = "udp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "positive6_ingress_2_rule" {
  security_group_id = aws_security_group.positive.id
  from_port         = 135
  to_port           = 170
  ip_protocol       = "udp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "positive7_ingress_rule" {
  security_group_id = aws_security_group.positive.id
  from_port         = 2383
  to_port           = 2383
  ip_protocol       = "udp"
  cidr_ipv6         = "::/0"
  description       = "TLS from VPC"
}
