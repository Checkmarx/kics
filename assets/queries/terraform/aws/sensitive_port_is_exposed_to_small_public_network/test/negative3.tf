# ipv4
resource "aws_security_group_rule" "negative3_ipv4_1" {
  #incorrect protocol
  from_port    = 22
  to_port      = 22
  protocol     = "icmp"
  cidr_blocks  = ["10.0.0.0/25"]
  type         = "ingress"
}

resource "aws_security_group_rule" "negative3_ipv4_2" {
  #incorrect port range (unknown)
  from_port    = 5000
  to_port      = 5000
  protocol     = "tcp"
  cidr_blocks  = ["192.168.0.0/26"]
  type         = "ingress"
}

resource "aws_security_group_rule" "negative3_ipv4_3" {
  #incorrect cidr (not wide private network)
  from_port    = 22
  to_port      = 22
  protocol     = "udp"
  cidr_blocks  = ["1.0.0.0/2"]
  type         = "ingress"
}

resource "aws_security_group_rule" "negative3_ipv4_4" {
  #all incorrect 
  from_port    = 5000
  to_port      = 5000
  protocol     = "icmp"
  cidr_blocks  = ["10.68.0.0/14", "1.0.0.0/2"]
  type         = "ingress"
}

# ipv6

resource "aws_security_group_rule" "negative3_ipv6_1" {
  #incorrect protocol
  from_port         = 22
  to_port           = 22
  protocol          = "icmpv6"
  ipv6_cidr_blocks  = ["fd00::/121"]
  type              = "ingress"
}

resource "aws_security_group_rule" "negative3_ipv6_2" {
  #incorrect port range (unknown)
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["fd12:3456:789a::1/122"]
  type              = "ingress"
}

resource "aws_security_group_rule" "negative3_ipv6_3" {
  #incorrect cidr 
  from_port         = 22
  to_port           = 22
  protocol          = "udp"
  ipv6_cidr_blocks  = ["2400:cb00::/32"]
  type              = "ingress"
}

resource "aws_security_group_rule" "negative3_ipv6_4" {
  #all incorrect
  from_port         = 5000
  to_port           = 5000
  protocol          = "icmpv6"
  ipv6_cidr_blocks  = ["fd03:5678::/64", "2400:cb00::/32"]
  type              = "ingress"
}
