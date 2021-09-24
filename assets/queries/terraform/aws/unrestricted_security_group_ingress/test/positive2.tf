resource "aws_security_group" "positive2" {
  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.default.id
  }
}
