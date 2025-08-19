resource "aws_security_group" "positive3" {
  name        = "allow_tls_1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "positive3_1_rule" {
  type              = "ingress"
  from_port         = 2300
  to_port           = 2400
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.positive3.id
  description       = "TLS from VPC"
}

resource "aws_security_group_rule" "positive3_2_b" {
  type              = "ingress"
  from_port         = 2350
  to_port           = 2384
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.positive3.id
  description       = "TLS from VPC"
}

resource "aws_security_group_rule" "positive3_3_rule" {
  type              = "ingress"
  from_port         = 2200
  to_port           = 2500
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.positive3.id
  description       = "Remote desktop open private"
}
