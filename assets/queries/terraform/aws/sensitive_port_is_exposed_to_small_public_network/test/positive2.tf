# ipv4
resource "aws_vpc_security_group_ingress_rule" "positive2_ipv4_1" {
  from_port         = 22
  to_port           = 22
  ip_protocol       = "-1"
  cidr_ipv4         = "203.0.113.0/25"
}

resource "aws_vpc_security_group_ingress_rule" "positive2_ipv4_2" {
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "198.51.100.0/26"
}

resource "aws_vpc_security_group_ingress_rule" "positive2_ipv4_3" {
  from_port         = 22
  to_port           = 22
  ip_protocol       = "udp"
  cidr_ipv4         = "8.8.8.0/27"
}

resource "aws_vpc_security_group_ingress_rule" "positive2_ipv4_4" {
  from_port         = 110
  to_port           = 110
  ip_protocol       = "udp"
  cidr_ipv4         = "1.1.1.0/27"
}

# ipv6

resource "aws_vpc_security_group_ingress_rule" "positive2_ipv6_1" {
  from_port         = 22
  to_port           = 22
  ip_protocol       = "-1"
  cidr_ipv6         = "2400:cb00::/121"
}

resource "aws_vpc_security_group_ingress_rule" "positive2_ipv6_2" {
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv6         = "2606:4700:4700::1/122"
}

resource "aws_vpc_security_group_ingress_rule" "positive2_ipv6_3" {
  from_port         = 22
  to_port           = 22
  ip_protocol       = "udp"
  cidr_ipv6         = "2001:4860:4860::42/123"
}

resource "aws_vpc_security_group_ingress_rule" "positive2_ipv6_4" {
  from_port         = 110
  to_port           = 110
  ip_protocol       = "udp"
  cidr_ipv6         = "2001:4860:4860::42/123"
}
