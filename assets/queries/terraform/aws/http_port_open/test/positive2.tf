resource "aws_security_group" "ec2" {
  description = "ec2 sg"
  name        = "secgroup-ec2"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "positive2_1" {
  security_group_id = aws_security_group.ec2.id
  description = "allows RDP from Internet"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 70 
  ip_protocol = "tcp"
  to_port     = 82
}

resource "aws_vpc_security_group_ingress_rule" "positive2_2" {
  security_group_id = aws_security_group.ec2.id
  description = "allows RDP from Internet"

  cidr_ipv6   = "::/0"
  from_port   = 79 
  ip_protocol = "-1"
  to_port     = 100
}