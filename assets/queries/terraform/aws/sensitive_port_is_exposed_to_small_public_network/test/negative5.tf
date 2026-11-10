resource "aws_security_group" "negative5_tcp_inline" {
  name = "negative5_tcp_inline"

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["200.1.1.0/26"]
  }
}

resource "aws_security_group_rule" "negative5_tcp_rule" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["200.1.1.0/26"]
  security_group_id = "sg-1"
}

resource "aws_vpc_security_group_ingress_rule" "negative5_tcp_vpc_rule" {
  security_group_id = "sg-1"
  ip_protocol       = "tcp"
  from_port         = 0
  to_port           = 0
  cidr_ipv4         = "200.1.1.0/26"
}

resource "aws_security_group" "negative5_udp_inline" {
  name = "negative5_udp_inline"

  ingress {
    protocol    = "udp"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["200.1.1.0/26"]
  }
}

resource "aws_security_group_rule" "negative5_udp_rule" {
  type              = "ingress"
  protocol          = "udp"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["200.1.1.0/26"]
  security_group_id = "sg-1"
}

resource "aws_vpc_security_group_ingress_rule" "negative5_udp_vpc_rule" {
  security_group_id = "sg-1"
  ip_protocol       = "udp"
  from_port         = 0
  to_port           = 0
  cidr_ipv4         = "200.1.1.0/26"
}
