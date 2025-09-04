resource "aws_security_group" "positive" {
  name        = "allow_tls1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "positive1_rule" {
  type              = "ingress"
  from_port         = 2200
  to_port           = 2500
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.positive.id
}

resource "aws_security_group_rule" "positive2_rule" {
  type              = "ingress"
  from_port         = 20
  to_port           = 60
  protocol          = "tcp"
  cidr_blocks       = ["/0"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.positive.id
}

resource "aws_security_group_rule" "positive3_rule" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 6000
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.positive.id
}

resource "aws_security_group_rule" "positive4_rule" {
  type              = "ingress"
  from_port         = 20
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["/0"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.positive.id
}

resource "aws_security_group_rule" "positive5_rule_2" {
  type              = "ingress"
  from_port         = 445
  to_port           = 500
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.positive.id
}

resource "aws_security_group_rule" "positive6_rule_2" {
  type              = "ingress"
  from_port         = 135
  to_port           = 170
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.positive.id
}

resource "aws_security_group_rule" "positive7_rule" {
  type              = "ingress"
  from_port         = 2383
  to_port           = 2383
  protocol          = "udp"
  ipv6_cidr_blocks  = ["::/0"]
  description       = "TLS from VPC"
  security_group_id = aws_security_group.positive.id
}
