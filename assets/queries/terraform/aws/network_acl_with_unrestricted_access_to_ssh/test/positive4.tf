resource "aws_network_acl" "positive4_single" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol   = "6"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
}

resource "aws_network_acl" "positive4_list" {
  vpc_id = aws_vpc.main.id

  ingress = [
    {
      protocol   = "6"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 22
      to_port    = 22
    }
  ]
}

resource "aws_network_acl" "positive4_rule" {
  vpc_id = aws_vpc.main.id
}

resource "aws_network_acl_rule" "positive4_rule" {
  network_acl_id = aws_network_acl.positive4_rule.id
  rule_number    = 100
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

module "positive4_module" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  default_network_acl_ingress = [
    {
      "action" : "allow",
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 22,
      "protocol" : "6",
      "rule_no" : 100,
      "to_port" : 22
    }
  ]
}
