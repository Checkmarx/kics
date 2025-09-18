resource "aws_security_group_rule" "negative3-1" {

  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  description       = "sample_description"
}

resource "aws_security_group_rule" "negative3-2" {

  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
  description       = "sample_description"
}