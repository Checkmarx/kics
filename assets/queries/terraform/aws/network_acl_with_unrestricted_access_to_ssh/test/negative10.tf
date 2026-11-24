resource "aws_network_acl_rule" "deny_rdp_ingress" {
  network_acl_id = aws_network_acl.example.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}
