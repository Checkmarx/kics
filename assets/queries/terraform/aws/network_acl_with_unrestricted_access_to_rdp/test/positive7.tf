resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_network_acl" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_network_acl_rule" "allow_rdp_ipv6_ingress" {
  network_acl_id  = aws_network_acl.example.id
  rule_number     = 100
  egress          = false
  protocol        = "tcp"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
  from_port       = 3389
  to_port         = 3389
}