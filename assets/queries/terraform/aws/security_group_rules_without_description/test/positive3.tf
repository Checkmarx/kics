resource "aws_security_group" "positive3" {

  name        = "${var.prefix}-external-http-https"
  description = "Allow main HTTP / HTTPS"
  vpc_id      = local.vpc_id

  tags = {
    Name = "${var.prefix}-external-http-https"
  }
}

resource "aws_security_group_rule" "positive3a" {

  description       = "Enable HTTP access for select VMs"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.positive3.id
  type              = "ingress"
}

resource "aws_security_group_rule" "positive3b" {

  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.positive3.id
  type              = "ingress"
}
