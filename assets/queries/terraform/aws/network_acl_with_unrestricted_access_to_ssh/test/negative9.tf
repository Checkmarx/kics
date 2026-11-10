resource "aws_network_acl" "negative9_single" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol   = "6"
    rule_no    = 100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_network_acl" "negative9_list" {
  vpc_id = aws_vpc.main.id

  ingress = [
    {
      protocol   = "6"
      rule_no    = 100
      action     = "deny"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  ]
}

resource "aws_network_acl" "negative9_rule" {
  vpc_id = aws_vpc.main.id
}

resource "aws_network_acl_rule" "negative9_rule" {
  network_acl_id = aws_network_acl.negative9_rule.id
  rule_number    = 100
  egress         = false
  protocol       = "6"
  rule_action    = "deny"
  cidr_block = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

module "negative9_module" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  default_network_acl_ingress = [
    {
      "action" : "deny",
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 0,
      "protocol" : "6",
      "rule_no" : 100,
      "to_port" : 0
    }
  ]
}
