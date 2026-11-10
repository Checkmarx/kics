resource "aws_network_acl" "positive5_single" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    ipv6_cidr_block = "::/0"
    from_port  = 22
    to_port    = 22
  }
}

resource "aws_network_acl" "positive5_list" {
  vpc_id = aws_vpc.main.id

  ingress = [
    {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      ipv6_cidr_block = "::/0"
      from_port  = 22
      to_port    = 22
    }
  ]
}

resource "aws_network_acl" "positive5_rule" {
  vpc_id = aws_vpc.main.id
}

resource "aws_network_acl_rule" "positive5_rule" {
  network_acl_id = aws_network_acl.positive5_rule.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  ipv6_cidr_block = "::/0"
  from_port      = 22
  to_port        = 22
}

module "positive5_module" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  default_network_acl_ingress = [
    {
      "action" : "allow",
      "ipv6_cidr_block" : "::/0",
      "from_port" : 22,
      "protocol" : "tcp",
      "rule_no" : 100,
      "to_port" : 22
    }
  ]
}
