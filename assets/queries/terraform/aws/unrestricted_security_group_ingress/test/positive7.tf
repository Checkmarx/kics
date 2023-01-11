resource "aws_security_group" "positive7" {
  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    ipv6_cidr_blocks  = ["::/0"]
    security_group_id = aws_security_group.default.id
  }
}
