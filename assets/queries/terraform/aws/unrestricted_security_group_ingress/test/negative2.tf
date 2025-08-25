resource "aws_vpc_security_group_ingress_rule" "negative2-ipv4" {
  security_group_id = aws_security_group.default.id
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.2.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "negative2-ipv6" {
  security_group_id = aws_security_group.default.id
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  cidr_ipv6         = "fc00::/8"
}