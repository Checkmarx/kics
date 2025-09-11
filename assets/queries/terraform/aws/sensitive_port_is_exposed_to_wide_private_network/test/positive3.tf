resource "aws_security_group" "positive" {
  name        = "shared_tls_group"
  description = "Security group with multiple ingress rules"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "positive1" {
  type              = "ingress"
  from_port         = 2200
  to_port           = 2500
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/8"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.positive.id
}

resource "aws_security_group_rule" "positive2" {
  type              = "ingress"
  from_port         = 20
  to_port           = 60
  protocol          = "tcp"
  cidr_blocks       = ["192.168.0.0/16"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.positive.id
}

resource "aws_security_group_rule" "positive3" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 6000
  protocol          = "-1"
  cidr_blocks       = ["172.16.0.0/12"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.positive.id
}

resource "aws_security_group_rule" "positive4" {
  type              = "ingress"
  from_port         = 20
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.positive.id
}

resource "aws_security_group_rule" "positive5a" {
  type              = "ingress"
  from_port         = 445
  to_port           = 500
  protocol          = "udp"
  cidr_blocks       = ["192.168.0.0/16"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.positive.id
}

resource "aws_security_group_rule" "positive6a" {
  type              = "ingress"
  from_port         = 135
  to_port           = 170
  protocol          = "udp"
  cidr_blocks       = ["10.68.0.0"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.positive.id
}

resource "aws_security_group_rule" "positive7a" {
  type              = "ingress"
  from_port         = 2383
  to_port           = 2383
  protocol          = "udp"
  cidr_blocks       = ["192.168.0.0/16"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.positive.id
}