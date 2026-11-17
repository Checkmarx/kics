resource "aws_network_acl" "acl" {
  vpc_id = "vpc-1"
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 3389
    to_port    = 3389
  }
}