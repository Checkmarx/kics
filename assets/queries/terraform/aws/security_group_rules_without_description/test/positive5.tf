module "positive5_ipv4_array" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_with_cidr_blocks = [
    {
      from_port   = 2383
      to_port     = 2383
      protocol    = "udp"
      cidr_blocks = ["0.1.1.1/21", "8.8.8.8/24"]
    },
    {
      from_port   = 28000
      to_port     = 28001
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 2383
      to_port     = 2383
      protocol    = "udp"
      cidr_blocks = ["0.1.1.1/21", "8.8.8.8/24"]
    },
    {
      from_port   = 28000
      to_port     = 28001
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]
}

module "positive5_ipv6_array" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = 2383
      to_port          = 2383
      protocol         = "udp"
      ipv6_cidr_blocks = ["fd00::/8", "2001:4860:4860::8888/64"]
    },
    {
      from_port        = 28000
      to_port          = 28001
      protocol         = "tcp"
      ipv6_cidr_blocks = ["fc00::/7"]
    }
  ]

  egress_with_ipv6_cidr_blocks = [
    {
      from_port        = 2383
      to_port          = 2383
      protocol         = "udp"
      ipv6_cidr_blocks = ["fd00::/8", "2001:4860:4860::8888/64"]
    },
    {
      from_port        = 28000
      to_port          = 28001
      protocol         = "tcp"
      ipv6_cidr_blocks = ["fc00::/7"]
    }
  ]
}