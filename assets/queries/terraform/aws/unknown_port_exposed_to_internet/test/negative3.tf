resource "aws_security_group" "negative3" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "negative3_1_rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.negative3.id
}

resource "aws_security_group_rule" "negative3_2_rule" {
  type              = "ingress"
  from_port         = 2383
  to_port           = 2383
  protocol          = "tcp"
  cidr_blocks       = ["192.168.0.0/24", "192.162.0.0/24"]
  security_group_id = aws_security_group.negative3.id
}

resource "aws_security_group_rule" "negative3_3_rule" {
  type              = "ingress"
  from_port         = 20
  to_port           = 20
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["2001:db8:abcd:0012::/64"]
  security_group_id = aws_security_group.negative3.id
}
