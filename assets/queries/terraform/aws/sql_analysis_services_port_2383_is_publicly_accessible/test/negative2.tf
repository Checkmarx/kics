resource "aws_security_group" "negative" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "negative2-1" {
  security_group_id = aws_security_group.negative.id
  from_port         = 2383
  to_port           = 2383
  ip_protocol       = "tcp"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "negative2-2" {
  security_group_id = aws_security_group.negative.id
  cidr_ipv4         = "0.1.0.0/0"
  from_port         = 2383
  to_port           = 2383
  ip_protocol       = "tcp"
  description       = "Remote desktop open private"
}

resource "aws_vpc_security_group_ingress_rule" "negative2-3" {
  security_group_id = aws_security_group.negative.id
  cidr_ipv6         = "2001:db8:abcd:0012::/64"
  from_port         = 2200
  to_port           = 2500
  ip_protocol       = "tcp"
  description       = "Remote desktop open private"
}

resource "aws_vpc_security_group_ingress_rule" "negative2-4" {
  security_group_id = aws_security_group.negative.id
  cidr_ipv6         = "::/0"
  from_port         = 20
  to_port           = 2000
  ip_protocol       = "tcp"
  description       = "Remote desktop open private"
}

resource "aws_vpc_security_group_ingress_rule" "negative2-5" {
  security_group_id = aws_security_group.negative.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 20
  to_port           = 2000
  ip_protocol       = "tcp"
  description       = "Remote desktop open private"
}

resource "aws_vpc_security_group_ingress_rule" "negative2-6" {
  security_group_id = aws_security_group.negative.id
  cidr_ipv6         = "::/0"
  from_port         = 2200
  to_port           = 2500
  ip_protocol       = "udp"
  description       = "Remote desktop open private"
}

resource "aws_vpc_security_group_ingress_rule" "negative2-7" {
  security_group_id = aws_security_group.negative.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 2200
  to_port           = 2500
  ip_protocol       = "udp"
  description       = "Remote desktop open private"
}