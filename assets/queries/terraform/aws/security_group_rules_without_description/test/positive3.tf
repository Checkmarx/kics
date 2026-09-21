resource "aws_security_group_rule" "positive3-1" {

  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
}

resource "aws_security_group_rule" "positive3-2" {

  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}