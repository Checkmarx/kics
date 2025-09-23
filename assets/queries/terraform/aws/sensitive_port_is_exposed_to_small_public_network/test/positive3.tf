# ipv4
resource "aws_security_group_rule" "positive3_ipv4_1" {
  from_port    = 22
  to_port      = 22
  protocol     = "-1"
  cidr_blocks  = ["10.0.0.0/25"]
  type         = "ingress"
}

resource "aws_security_group_rule" "positive3_ipv4_2" {
  from_port    = 22
  to_port      = 22
  protocol     = "tcp"
  cidr_blocks  = ["192.168.0.0/26"]
  type         = "ingress"
}

resource "aws_security_group_rule" "positive3_ipv4_3" {
  from_port    = 22
  to_port      = 22
  protocol     = "udp"
  cidr_blocks  = ["172.16.0.0/27"]
  type         = "ingress"
}

resource "aws_security_group_rule" "positive3_ipv4_4" {
  from_port    = 110
  to_port      = 110
  protocol     = "udp"
  cidr_blocks  = ["10.68.0.0", "172.16.0.0/27"]
  type         = "ingress"
}

# ipv6

resource "aws_security_group_rule" "positive3_ipv6_1" {
  from_port         = 22
  to_port           = 22
  protocol          = "-1"
  ipv6_cidr_blocks  = ["fd00::/121"]
  type              = "ingress"
}

resource "aws_security_group_rule" "positive3_ipv6_2" {
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["fd12:3456:789a::1/122"]
  type              = "ingress"
}

resource "aws_security_group_rule" "positive3_ipv6_3" {
  from_port         = 22
  to_port           = 22
  protocol          = "udp"
  ipv6_cidr_blocks  = ["fd00:abcd:1234::42/123"]
  type              = "ingress"
}

resource "aws_security_group_rule" "positive3_ipv6_4" {
  from_port         = 110
  to_port           = 110
  protocol          = "udp"
  ipv6_cidr_blocks  = ["fd03:5678::/64", "fd00:abcd:1234::42/123"] 
  type              = "ingress"
}
