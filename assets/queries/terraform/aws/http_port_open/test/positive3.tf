resource "aws_security_group" "ec2" {
  description = "ec2 sg"
  name        = "secgroup-ec2"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "positive3_1" {
  type              = "ingress"
  from_port         = 70
  to_port           = 82
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
  description        = "allows RDP from Internet (IPv4)"
}

resource "aws_security_group_rule" "positive3_2" {
  type              = "ingress"
  from_port         = 79
  to_port           = 100
  protocol          = "-1" 
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.ec2.id
  description        = "allows RDP from Internet (IPv6)"
}
