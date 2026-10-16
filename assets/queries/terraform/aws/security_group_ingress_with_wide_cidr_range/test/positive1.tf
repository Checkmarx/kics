resource "aws_security_group" "positive1" {
  name = "positive1"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/1"]
  }
}

resource "aws_security_group" "positive2" {
  name = "positive2"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/7"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "positive3" {
  security_group_id = aws_security_group.positive1.id
  cidr_ipv4         = "128.0.0.0/1"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
