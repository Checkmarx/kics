resource "aws_security_group_rule" "positive1" {
  type              = "ingress"
  from_port         = 2200
  to_port           = 2500
  protocol          = "-1"
  cidr_blocks       = ["12.0.0.0/25"]
  security_group_id = aws_security_group.allow_tls1.id
}

resource "aws_security_group_rule" "positive2" {
  type              = "ingress"
  from_port         = 20
  to_port           = 60
  protocol          = "tcp"
  cidr_blocks       = ["1.2.3.4/26"]
  security_group_id = aws_security_group.allow_tls2.id
}

resource "aws_security_group_rule" "positive3" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 6000
  protocol          = "-1"
  cidr_blocks       = ["2.12.22.33/27"]
  security_group_id = aws_security_group.allow_tls3.id
}

resource "aws_security_group_rule" "positive4" {
  type              = "ingress"
  from_port         = 20
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.92.168.0/28"]
  security_group_id = aws_security_group.allow_tls4.id
}

resource "aws_security_group_rule" "positive5" {
  type              = "ingress"
  from_port         = 445
  to_port           = 500
  protocol          = "udp"
  cidr_blocks       = ["1.1.1.1/29", "0.0.0.0/0", "2.2.3.4/12"]
  security_group_id = aws_security_group.allow_tls5.id
}

resource "aws_security_group_rule" "positive6" {
  type              = "ingress"
  from_port         = 135
  to_port           = 170
  protocol          = "udp"
  cidr_blocks       = ["10.68.0.0", "0.0.0.0/28"]
  security_group_id = aws_security_group.allow_tls6.id
}

resource "aws_security_group_rule" "positive7" {
  type              = "ingress"
  from_port         = 2383
  to_port           = 2383
  protocol          = "udp"
  cidr_blocks       = ["/0", "1.2.3.4/27"]
  security_group_id = aws_security_group.allow_tls7.id
}
