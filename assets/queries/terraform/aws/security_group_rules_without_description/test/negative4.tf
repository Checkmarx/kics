resource "aws_vpc_security_group_ingress_rule" "negative4-1" {
  description       = "sample_description"
  cidr_ipv4         = "192.168.1.0/24"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "negative4-2" {
  description       = "sample_description"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
}