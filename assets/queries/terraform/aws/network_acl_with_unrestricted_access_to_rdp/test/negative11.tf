module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  default_network_acl_ingress = [
    {
      "rule_no": 100
      "action": "deny"
      "from_port": 3389
      "to_port": 3389
      "protocol": "tcp"
      "cidr_block": "0.0.0.0/0"
    },
  ]
}