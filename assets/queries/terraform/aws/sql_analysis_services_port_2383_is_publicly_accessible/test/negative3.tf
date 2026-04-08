resource "aws_security_group" "negative" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "negative3-1" {
  type              = "ingress"
  from_port         = 2383
  to_port           = 2383
  protocol          = "tcp"
  security_group_id = aws_security_group.negative.id
  description       = "TLS from VPC"
}

resource "aws_security_group_rule" "negative3-2" {
  type              = "ingress"
  from_port         = 2383
  to_port           = 2383
  protocol          = "tcp"
  cidr_blocks       = ["0.1.0.0/0"]
  security_group_id = aws_security_group.negative.id
  description       = "Remote desktop open private"
}

resource "aws_security_group_rule" "negative3-3" {
  type              = "ingress"
  from_port         = 2200
  to_port           = 2500
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["2001:db8:abcd:0012::/64"]
  security_group_id = aws_security_group.negative.id
  description       = "Remote desktop open private"
}

resource "aws_security_group_rule" "negative3-4" {
  type              = "ingress"
  from_port         = 20
  to_port           = 2000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.negative.id
  description       = "Remote desktop open private"
}

resource "aws_security_group_rule" "negative3-5" {
  type              = "ingress"
  from_port         = 20
  to_port           = 2000
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.negative.id
  description       = "Remote desktop open private"
}

resource "aws_security_group_rule" "negative3-6" {
  type              = "ingress"
  from_port         = 2383
  to_port           = 2383
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.negative.id
  description       = "Remote desktop open private"
}

resource "aws_security_group_rule" "negative3-7" {
  type              = "ingress"
  from_port         = 2383
  to_port           = 2383
  protocol          = "udp"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.negative.id
  description       = "Remote desktop open private"
}
