resource "aws_vpc_security_group_ingress_rule" "positive1_ingress" {
  security_group_id = aws_security_group.allow_tls1.id
  cidr_ipv4         = "12.0.0.0/25"
  from_port         = 2200
  to_port           = 2500
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "positive2_ingress" {
  security_group_id = aws_security_group.allow_tls2.id
  cidr_ipv4         = "1.2.3.4/26"
  from_port         = 20
  to_port           = 60
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "positive3_ingress" {
  security_group_id = aws_security_group.allow_tls3.id
  cidr_ipv4         = "2.12.22.33/27"
  from_port         = 5000
  to_port           = 6000
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "positive4_ingress" {
  security_group_id = aws_security_group.allow_tls4.id
  cidr_ipv4         = "10.92.168.0/28"
  from_port         = 20
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "positive5_1_ingress" {
  security_group_id = aws_security_group.allow_tls5.id
  cidr_ipv4         = "1.1.1.1/29"
  from_port         = 445
  to_port           = 500
  ip_protocol       = "udp"
}

resource "aws_vpc_security_group_ingress_rule" "positive6_2_ingress" {
  security_group_id = aws_security_group.allow_tls6.id
  cidr_ipv4         = "0.0.0.0/28"
  from_port         = 135
  to_port           = 170
  ip_protocol       = "udp"
}

resource "aws_vpc_security_group_ingress_rule" "positive7_2_ingress" {
  security_group_id = aws_security_group.allow_tls7.id
  cidr_ipv4         = "1.2.3.4/27"
  from_port         = 2383
  to_port           = 2383
  ip_protocol       = "udp"
}
