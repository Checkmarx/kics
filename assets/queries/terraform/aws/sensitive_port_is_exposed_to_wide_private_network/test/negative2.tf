resource "aws_security_group" "negative" {
  name        = "shared_tls_group"
  description = "Security group with multiple ingress rules"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "negative1" {
  security_group_id = aws_security_group.negative.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 2383
  to_port           = 2383
  ip_protocol       = "tcp"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "negative2" {
  security_group_id = aws_security_group.negative.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 2384
  to_port           = 2386
  ip_protocol       = "tcp"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "negative3" {
  security_group_id = aws_security_group.negative.id
  cidr_ipv4         = "1.2.3.4/0"
  from_port         = 25
  to_port           = 2500
  ip_protocol       = "tcp"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "negative4" {
  security_group_id = aws_security_group.negative.id
  cidr_ipv4         = "1.2.3.4/5"
  from_port         = 25
  to_port           = 2500
  ip_protocol       = "tcp"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "negative5a" {
  security_group_id = aws_security_group.negative.id
  cidr_ipv4         = "1.2.3.4/5"
  from_port         = 25
  to_port           = 2500
  ip_protocol       = "udp"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "negative5b" {
  security_group_id = aws_security_group.negative.id
  cidr_ipv4         = "0.0.0.0/12"
  from_port         = 25
  to_port           = 2500
  ip_protocol       = "udp"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "negative6a" {
  security_group_id = aws_security_group.negative.id
  cidr_ipv4         = "1.2.3.4"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "negative6b" {
  security_group_id = aws_security_group.negative.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  description       = "TLS from VPC"
}
