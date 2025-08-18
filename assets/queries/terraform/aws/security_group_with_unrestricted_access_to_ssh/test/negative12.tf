resource "aws_security_group" "negative1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group_rule" "tls_ipv6_fd00" {
  type              = "ingress"
  security_group_id = aws_security_group.negative1.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["fd00::/8"]
  description       = "TLS from fd00::/8"
}

resource "aws_security_group_rule" "tls_ipv6_fd01" {
  type              = "ingress"
  security_group_id = aws_security_group.negative1.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["fd01::/8"]
  description       = "TLS from fd01::/8"
}

resource "aws_security_group_rule" "egress_ipv6_all" {
  type              = "egress"
  security_group_id = aws_security_group.negative1.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow all outbound IPv6 traffic"
}
