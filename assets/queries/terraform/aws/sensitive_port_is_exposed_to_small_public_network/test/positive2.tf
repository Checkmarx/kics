# ipv4
resource "aws_vpc_security_group_ingress_rule" "positive2_ipv4_1" {
  from_port         = 22
  to_port           = 22
  ip_protocol       = "-1"
  cidr_ipv4         = "10.0.0.0/25"
}

resource "aws_vpc_security_group_ingress_rule" "positive2_ipv4_2" {
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "192.168.0.0/26"
}

resource "aws_vpc_security_group_ingress_rule" "positive2_ipv4_3" {
  from_port         = 22
  to_port           = 22
  ip_protocol       = "udp"
  cidr_ipv4         = "172.16.0.0/27"
}

resource "aws_vpc_security_group_ingress_rule" "positive2_ipv4_4" {
  from_port         = 110
  to_port           = 110
  ip_protocol       = "udp"
  cidr_ipv4         = "172.16.0.0/27"
}

# ipv6

resource "aws_vpc_security_group_ingress_rule" "positive2_ipv6_1" {
  from_port         = 22
  to_port           = 22
  ip_protocol       = "-1"
  cidr_ipv6         = "fd00::/121" 
}

resource "aws_vpc_security_group_ingress_rule" "positive2_ipv6_2" {
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv6         = "fd12:3456:789a::1/122"
}

resource "aws_vpc_security_group_ingress_rule" "positive2_ipv6_3" {
  from_port         = 22
  to_port           = 22
  ip_protocol       = "udp"
  cidr_ipv6         = "fd00:abcd:1234::42/123"
}

resource "aws_vpc_security_group_ingress_rule" "positive2_ipv6_4" {
  from_port         = 110
  to_port           = 110
  ip_protocol       = "udp"
  cidr_ipv6         = "fd00:abcd:1234::42/123"
}
