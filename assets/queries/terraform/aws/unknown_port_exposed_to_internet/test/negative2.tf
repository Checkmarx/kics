resource "aws_security_group" "negative2" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "negative2-1" {
  security_group_id = aws_security_group.negative3.id
  from_port         = 2383
  to_port           = 2383
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Remote desktop open private"
}


resource "aws_vpc_security_group_ingress_rule" "negative2-2" {
  security_group_id = aws_security_group.negative3.id
  from_port         = 20
  to_port           = 20
  ip_protocol       = "tcp"
  cidr_ipv6         = "::/0"
  description       = "Remote desktop open private"
}

resource "aws_vpc_security_group_ingress_rule" "negative2-3" {
  security_group_id = aws_security_group.negative3.id
  from_port         = 0
  to_port           = 10000
  ip_protocol       = "tcp"
  cidr_ipv4         = "192.168.0.0/24"
  description       = "Remote desktop open private"
}


resource "aws_vpc_security_group_ingress_rule" "negative2-4" {
  security_group_id = aws_security_group.negative3.id
  from_port         = 0
  to_port           = 10000
  ip_protocol       = "tcp"
  cidr_ipv6         = "2001:db8:abcd:0012::/64"
  description       = "Remote desktop open private"
}