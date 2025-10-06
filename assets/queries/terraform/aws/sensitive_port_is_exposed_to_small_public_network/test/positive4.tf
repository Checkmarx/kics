module "positive4_ipv4_1" {
  source  = "terraform-aws-modules/security-group/aws"
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "-1"
      cidr_blocks = ["10.0.0.0/25"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["192.168.0.0/26"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "udp"
      cidr_blocks = ["172.16.0.0/27"]
    },
    {
      from_port   = 110
      to_port     = 110
      protocol    = "udp"
      cidr_blocks = ["10.68.0.0", "172.16.0.0/27"]
    }
  ]
}

module "positive4_ipv6_1" {
  source  = "terraform-aws-modules/security-group/aws"
  ingress_with_ipv6_cidr_blocks = [
    {
      from_port         = 22
      to_port           = 22
      protocol          = "-1"
      ipv6_cidr_blocks  = ["fd00::/121"]
    },
    {
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      ipv6_cidr_blocks  = ["fd12:3456:789a::1/122"]
    },
    {
      from_port         = 22
      to_port           = 22
      protocol          = "udp"
      ipv6_cidr_blocks  = ["fd00:abcd:1234::42/123"]
    },
    {
      from_port         = 110
      to_port           = 110
      protocol          = "udp"
      ipv6_cidr_blocks  = ["fd03:5678::/64", "fd00:abcd:1234::42/123"]
    }
  ]
}
