resource "aws_security_group" "positive1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group_rule" "tls_ipv6_anywhere" {
  type              = "ingress"
  security_group_id = aws_security_group.positive1.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
  description       = "TLS from anywhere (IPv6)"
}
