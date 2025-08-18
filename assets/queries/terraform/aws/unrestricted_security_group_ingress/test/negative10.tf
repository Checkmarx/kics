resource "aws_vpc_security_group_ingress_rule" "positive12" {
  security_group_id = aws_security_group.default.id
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  cidr_ipv6         = "fc00::/8"
}
