resource "aws_network_acl" "acl" {
  vpc_id = "vpc-1"
  ingress {
    protocol   = "6"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 3389
    to_port    = 3389
  }
}