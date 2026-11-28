resource "aws_network_acl" "acl" {
  vpc_id = "vpc-1"
  ingress {
    protocol        = "tcp"
    rule_no         = 100
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 22
    to_port         = 22
  }
}