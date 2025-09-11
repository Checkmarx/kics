resource "aws_security_group" "negative" {
  name        = "shared_tls_group"
  description = "Security group with multiple ingress rules"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "negative1" {
  type              = "ingress"
  from_port         = 2383
  to_port           = 2383
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.main.cidr_block]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.negative.id
}

resource "aws_security_group_rule" "negative2" {
  type              = "ingress"
  from_port         = 2384
  to_port           = 2386
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.negative.id
}

resource "aws_security_group_rule" "negative3" {
  type              = "ingress"
  from_port         = 25
  to_port           = 2500
  protocol          = "tcp"
  cidr_blocks       = ["1.2.3.4/0"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.negative.id
}

resource "aws_security_group_rule" "negative4" {
  type              = "ingress"
  from_port         = 25
  to_port           = 2500
  protocol          = "tcp"
  cidr_blocks       = ["1.2.3.4/5"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.negative.id
}

resource "aws_security_group_rule" "negative5a" {
  type              = "ingress"
  from_port         = 25
  to_port           = 2500
  protocol          = "udp"
  cidr_blocks       = ["1.2.3.4/5"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.negative.id
}

resource "aws_security_group_rule" "negative5b" {
  type              = "ingress"
  from_port         = 25
  to_port           = 2500
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/12"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.negative.id
}

resource "aws_security_group_rule" "negative6a" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["1.2.3.4"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.negative.id
}

resource "aws_security_group_rule" "negative6b" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.negative.id
}
