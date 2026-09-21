resource "aws_security_group" "ec2" {
  description = "ec2 sg"
  name        = "secgroup-ec2"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "negative3-1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.negative.id
  description       = "TLS from VPC"
}

resource "aws_security_group_rule" "negative3-2" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.1.0/0"]
  security_group_id = aws_security_group.ec2.id
  description        = "allows RDP from Internet (IPv4)"
}

resource "aws_security_group_rule" "negative3-3" {
  type              = "ingress"
  from_port         = 79
  to_port           = 100
  protocol          = "-1" 
  ipv6_cidr_blocks  = ["2001:db8:abcd:0012::/64"]
  security_group_id = aws_security_group.ec2.id
  description       = "allows RDP from Internet (IPv6)"
}

resource "aws_security_group_rule" "negative3-4" {
  type              = "ingress"
  from_port         = 3380
  to_port           = 3580
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
  description        = "allows RDP from Internet (IPv4)"
}

resource "aws_security_group_rule" "negative3-5" {
  type              = "ingress"
  from_port         = 3380
  to_port           = 3580
  protocol          = "tcp" 
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.ec2.id
  description       = "allows RDP from Internet (IPv6)"
}

resource "aws_security_group_rule" "negative3-6" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
  description        = "allows RDP from Internet (IPv4)"
}

resource "aws_security_group_rule" "negative3-7" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
  description        = "allows RDP from Internet (IPv4)"
}