resource "aws_security_group_rule" "negative3-ipv4" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.2.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "negative3-ipv6" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["fc00::/8"]
  security_group_id = aws_security_group.default.id
}