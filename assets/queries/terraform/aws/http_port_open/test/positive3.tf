resource "aws_security_group" "ec2" {
  description = "ec2 sg"
  name        = "secgroup-ec2"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "positive3-1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
  description       = "HTTP port open"
}

resource "aws_security_group_rule" "positive3-2" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "-1" 
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.ec2.id
  description       = "HTTP port open"
}