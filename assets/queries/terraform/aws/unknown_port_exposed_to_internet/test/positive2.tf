resource "aws_security_group" "positive2" {
  name        = "allow_tls_1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "positive2-1" {
  security_group_id = aws_security_group.positive2.id
  description       = "Unknown port exposed"

  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 44
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "positive2-2" {
  security_group_id = aws_security_group.positive2.id
  description       = "Unknown port exposed"

  cidr_ipv6         = "::/0"
  from_port         = 600
  to_port           = 1200
  ip_protocol       = "tcp"
}