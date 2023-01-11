resource "aws_security_group" "negative3" {
  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    ipv6_cidr_blocks  = ["fc00::/9"]
  }

  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    ipv6_cidr_blocks  = ["fc00::/8"]
  }
}
