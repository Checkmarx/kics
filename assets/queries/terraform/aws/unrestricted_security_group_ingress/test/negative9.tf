resource "aws_vpc_security_group_ingress_rule" "positive11" {
  security_group_id = aws_security_group.default.id
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.2.0/0"
}
