resource "aws_network_acl" "negative8" {
  vpc_id = aws_vpc.main.id
}

resource "aws_network_acl_rule" "negative8" {
  network_acl_id = aws_network_acl.negative8.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block = "0.0.0.0/0"
  from_port      = 3389
  to_port        = 3389
}
