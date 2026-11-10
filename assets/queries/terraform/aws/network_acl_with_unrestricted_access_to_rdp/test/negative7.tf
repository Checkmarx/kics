resource "aws_network_acl" "negative7_single" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 3389
    to_port    = 3389
  }
}

resource "aws_network_acl" "negative7_list" {
  vpc_id = aws_vpc.main.id

  ingress = [
    {
      protocol   = "tcp"
      rule_no    = 100
      action     = "deny"
      cidr_block = "0.0.0.0/0"
      from_port  = 3389
      to_port    = 3389
    }
  ]
}

resource "aws_network_acl" "negative7_rule" {
  vpc_id = aws_vpc.main.id
}

resource "aws_network_acl_rule" "negative7_rule" {
  network_acl_id = aws_network_acl.negative7_rule.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "deny"
  cidr_block = "0.0.0.0/0"
  from_port      = 3389
  to_port        = 3389
}

module "negative7_module" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  default_network_acl_ingress = [
    {
      "action" : "deny",
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 3389,
      "protocol" : "tcp",
      "rule_no" : 100,
      "to_port" : 3389
    }
  ]
}
