resource "aws_security_group" "negative1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "tls_from_vpc" {
  security_group_id = aws_security_group.negative1.id
  cidr_ipv4         = "192.120.0.0/16"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "TLS from 192.120.0.0/16"
}

resource "aws_vpc_security_group_ingress_rule" "tls_from_external" {
  security_group_id = aws_security_group.negative1.id
  cidr_ipv4         = "75.132.0.0/16"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "TLS from 75.132.0.0/16"
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.negative1.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}
