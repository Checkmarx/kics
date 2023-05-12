resource "aws_security_group" "negative3" {

  name        = "${var.prefix}-external-http-https"
  description = "Allow main HTTP / HTTPS"
  vpc_id      = local.vpc_id

  tags = {
    Name = "${var.prefix}-external-http-https"
  }
}

resource "aws_security_group_rule" "negative3a" {

  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.negative3.id
  type              = "ingress"
  description       = "Enable HTTP access for select VMs"
}

resource "aws_security_group_rule" "negative3b" {

  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.negative3.id
  type              = "ingress"
  description       = "Enable HTTPS access for select VMs"
}
