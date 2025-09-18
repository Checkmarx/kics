resource "aws_vpc_security_group_ingress_rule" "positive4-1" {
  cidr_ipv4         = "192.168.1.0/24"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "positive4-2" {
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
}