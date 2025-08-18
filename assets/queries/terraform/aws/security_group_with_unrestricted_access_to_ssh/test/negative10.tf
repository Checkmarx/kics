resource "aws_security_group" "negative1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "tls_ipv6_fd00" {
  security_group_id = aws_security_group.negative1.id
  cidr_ipv6         = "fd00::/8"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "TLS from fd00::/8"
}

resource "aws_vpc_security_group_ingress_rule" "tls_ipv6_fd01" {
  security_group_id = aws_security_group.negative1.id
  cidr_ipv6         = "fd01::/8"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "TLS from fd01::/8"
}

resource "aws_vpc_security_group_egress_rule" "egress_ipv6_all" {
  security_group_id = aws_security_group.negative1.id
  cidr_ipv6         = "::/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  description       = "Allow all outbound IPv6 traffic"
}
