resource "aws_security_group" "negative1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group_rule" "tls_from_vpc" {
  type              = "ingress"
  security_group_id = aws_security_group.negative1.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["192.120.0.0/16"]
  description       = "TLS from 192.120.0.0/16"
}

resource "aws_security_group_rule" "tls_from_external" {
  type              = "ingress"
  security_group_id = aws_security_group.negative1.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["75.132.0.0/16"]
  description       = "TLS from 75.132.0.0/16"
}

resource "aws_security_group_rule" "all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.negative1.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}
