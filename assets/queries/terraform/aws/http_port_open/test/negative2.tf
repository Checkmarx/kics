resource "aws_security_group" "ec2" {
  description = "ec2 sg"
  name        = "secgroup-ec2"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "negative2-1" {
  security_group_id = aws_security_group.negative.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "negative2-2" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4         = "0.0.1.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "allows RDP from Internet"
}

resource "aws_vpc_security_group_ingress_rule" "negative2-3" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv6         = "2001:db8:abcd:0012::/64"
  from_port         = 80 
  to_port           = 80
  ip_protocol       = "-1"
  description       = "allows RDP from Internet"
}

resource "aws_vpc_security_group_ingress_rule" "negative2-4" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv6         = "::/0"
  from_port         = 3380
  to_port           = 3459
  ip_protocol       = "tcp"
  description       = "allows RDP from Internet"
}

resource "aws_vpc_security_group_ingress_rule" "negative2-5" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3380
  to_port           = 3459
  ip_protocol       = "tcp"
  description       = "allows RDP from Internet"
}

resource "aws_vpc_security_group_ingress_rule" "negative2-6" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv6         = "::/0"
  from_port         = 80 
  to_port           = 80
  ip_protocol       = "udp"
  description       = "allows RDP from Internet"
}

resource "aws_vpc_security_group_ingress_rule" "negative2-7" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "udp"
  description       = "allows RDP from Internet"
}

