module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  default_network_acl_ingress = [
    {
      "rule_no": 100
      "action": "allow"
      "from_port": 3389
      "to_port": 3389
      "protocol": "tcp"
      "ipv6_cidr_block": "::/0"
    },
  ]
}