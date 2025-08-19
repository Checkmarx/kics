resource "aws_security_group" "positive2" {
  name        = "allow_tls_1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "positive1_1_rule" {
  security_group_id = aws_security_group.positive2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 2300
  to_port           = 2400
  ip_protocol       = "tcp"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "positive1_2_rule_2" {
  security_group_id = aws_security_group.positive2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 2350
  to_port           = 2384
  ip_protocol       = "tcp"
  description       = "TLS from VPC"
}

resource "aws_vpc_security_group_ingress_rule" "positive1_3_rule" {
  security_group_id = aws_security_group.positive2.id
  cidr_ipv6         = "::/0"
  from_port         = 2200
  to_port           = 2500
  ip_protocol       = "tcp"
  description       = "Remote desktop open private"
}
