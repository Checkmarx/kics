resource "aws_security_group" "positive3" {
  name        = "allow_tls_1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "positive3_1_rule" {
  type              = "ingress"
  from_port         = 44
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.positive3.id
  description       = "TLS from VPC"
}

resource "aws_security_group_rule" "positive3_2_b" {
  type              = "ingress"
  from_port         = 18
  to_port           = 18
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.positive3.id
  description       = "TLS from VPC"
}

resource "aws_security_group_rule" "positive3_3_rule" {
  type              = "ingress"
  from_port         = 600
  to_port           = 1200
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.positive3.id
  description       = "Remote desktop open private"
}
