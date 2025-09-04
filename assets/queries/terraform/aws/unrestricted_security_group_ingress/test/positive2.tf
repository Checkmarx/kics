resource "aws_vpc_security_group_ingress_rule" "positive2-ipv4" {
  security_group_id = aws_security_group.default.id
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow MySQL from anywhere"
}

resource "aws_vpc_security_group_ingress_rule" "positive2-ipv6_1" {
  security_group_id = aws_security_group.default.id
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  cidr_ipv6         = "::/0"
  description       = "Allow MySQL from anywhere over IPv6"
}

resource "aws_vpc_security_group_ingress_rule" "positive2-ipv6_2" {
  security_group_id = aws_security_group.default.id
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  cidr_ipv6         = "0000:0000:0000:0000:0000:0000:0000:0000/0"
  description       = "Allow MySQL from anywhere over IPv6"
}