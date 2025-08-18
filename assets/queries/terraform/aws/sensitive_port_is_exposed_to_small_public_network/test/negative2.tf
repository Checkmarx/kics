resource "aws_security_group_rule" "negative1" {
  type              = "ingress"
  from_port         = 2383
  to_port           = 2383
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.main.cidr_block]
  security_group_id = aws_security_group.allow_tls1.id
}

resource "aws_security_group_rule" "negative2" {
  type              = "ingress"
  from_port         = 2384
  to_port           = 2386
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_tls2.id
}

resource "aws_security_group_rule" "negative3" {
  type              = "ingress"
  from_port         = 25
  to_port           = 2500
  protocol          = "tcp"
  cidr_blocks       = ["1.2.3.4/0"]
  security_group_id = aws_security_group.allow_tls3.id
}

resource "aws_security_group_rule" "negative4" {
  type              = "ingress"
  from_port         = 25
  to_port           = 2500
  protocol          = "tcp"
  cidr_blocks       = ["1.2.3.4/5"]
  security_group_id = aws_security_group.allow_tls4.id
}

resource "aws_security_group_rule" "negative5" {
  type              = "ingress"
  from_port         = 25
  to_port           = 2500
  protocol          = "udp"
  cidr_blocks       = ["1.2.3.4/5", "0.0.0.0/12"]
  security_group_id = aws_security_group.allow_tls5.id
}

resource "aws_security_group_rule" "negative6" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["1.2.3.4", "0.0.0.0/0"]
  security_group_id = aws_security_group.allow_tls6.id
}
