module "positive4_ipv4_1" {
  source  = "terraform-aws-modules/security-group/aws"
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "-1"
      cidr_blocks = ["203.0.113.0/25"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["198.51.100.0/26"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "udp"
      cidr_blocks = ["8.8.8.0/27"]
    },
    {
      from_port   = 110
      to_port     = 110
      protocol    = "udp"
      cidr_blocks = ["10.68.0.0", "1.1.1.0/27"]
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
      ipv6_cidr_blocks  = ["2400:cb00::/121"]
    },
    {
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      ipv6_cidr_blocks  = ["2606:4700:4700::1/122"]
    },
    {
      from_port         = 22
      to_port           = 22
      protocol          = "udp"
      ipv6_cidr_blocks  = ["2001:4860:4860::42/123"]
    },
    {
      from_port         = 110
      to_port           = 110
      protocol          = "udp"
      ipv6_cidr_blocks  = ["fd03:5678::/64", "2001:4860:4860::42/123"]
    }
  ]
}
