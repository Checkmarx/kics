resource "aws_security_group_rule" "negative1" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.2.0/0"]
  security_group_id = aws_security_group.default.id
}

