resource "aws_network_acl" "acl" {
  vpc_id = "vpc-1"
}

resource "aws_network_acl_rule" "r" {
  network_acl_id = aws_network_acl.acl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 3389
  to_port        = 3389
}