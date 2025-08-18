resource "aws_security_group" "positive1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "tls_ipv6_anywhere" {
  security_group_id = aws_security_group.positive1.id
  cidr_ipv6         = "::/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "TLS from anywhere (IPv6)"
}

