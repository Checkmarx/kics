resource "aws_network_acl_rule" "deny_all_protocols_ingress" {
  network_acl_id = aws_network_acl.example.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
}