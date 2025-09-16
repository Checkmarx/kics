resource "aws_security_group" "positive4" {
  name        = "example-sg"
  description = "Example security group"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "positive4-1" {
  security_group_id = aws_security_group.example.id
  cidr_ipv4         = "192.168.1.0/24"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "positive4-2" {
  security_group_id = aws_security_group.example.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
}