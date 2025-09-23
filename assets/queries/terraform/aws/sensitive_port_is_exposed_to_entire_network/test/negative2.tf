# ipv4
resource "aws_vpc_security_group_ingress_rule" "negative2_ipv4_1" {
  #incorrect protocol
  from_port    = 22
  to_port      = 22
  ip_protocol  = "icmp"
  cidr_ipv4    = "10.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "negative2_ipv4_2" {
  #incorrect port range (unknown)
  from_port    = 5000
  to_port      = 5000
  ip_protocol  = "tcp"
  cidr_ipv4    = "192.168.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "negative2_ipv4_3" {
  #incorrect cidr (mask is not "/0")
  from_port    = 22
  to_port      = 22
  ip_protocol  = "udp"
  cidr_ipv4    = "8.8.0.0/16"
}

resource "aws_vpc_security_group_ingress_rule" "negative2_ipv4_4" {
  #all incorrect 
  from_port    = 5000
  to_port      = 5000
  ip_protocol  = "icmp"
  cidr_ipv4    = "8.8.0.0/16"
}

# ipv6

resource "aws_vpc_security_group_ingress_rule" "negative2_ipv6_1" {
  #incorrect protocol
  from_port         = 22
  to_port           = 22
  ip_protocol       = "icmpv6"
  cidr_ipv6         = "fd00::/0"  
}

resource "aws_vpc_security_group_ingress_rule" "negative2_ipv6_2" {
  #incorrect port range (unknown)
  from_port         = 5000
  to_port           = 5000
  ip_protocol       = "tcp"
  cidr_ipv6         = "fd12:3456:789a::1/0"  
}

resource "aws_vpc_security_group_ingress_rule" "negative2_ipv6_3" {
  #incorrect cidr (mask is not "/0")
  from_port         = 22
  to_port           = 22
  ip_protocol       = "udp"
  cidr_ipv6         = "2400:cb00::/32"  
}

resource "aws_vpc_security_group_ingress_rule" "negative2_ipv6_4" {
  #all incorrect
  from_port         = 5000
  to_port           = 5000
  ip_protocol       = "icmpv6"
  cidr_ipv6         = "2400:cb00::/32"
}
