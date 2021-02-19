resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.2.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group" "ingress_inside_neg_1" {
  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    cidr_blocks       = ["0.0.2.0/0"]
    security_group_id = aws_security_group.default.id
  }
}

resource "aws_security_group" "ingress_inside_neg_2" {
  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    cidr_blocks       = ["1.0.0.0/0"]
  }

  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    cidr_blocks       = ["0.0.1.0/0"]
  }
}
