module "vote_service_sg_ipv4" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_with_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["1.2.3.4"]
    }
  ]

  egress_with_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["1.2.3.4"]
    }
  ]
}

module "vote_service_sg_ipv4_array" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_with_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 2383
      to_port     = 2383
      protocol    = "udp"
      cidr_blocks = ["0.1.1.1/21", "8.8.8.8/24"]
    },
    {
      description = "TLS from VPC"
      from_port   = 28000
      to_port     = 28001
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    {
      description = "TLS from VPC"
      from_port   = 20
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["192.01.01.02/23"]
    }
  ]

  egress_with_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 2383
      to_port     = 2383
      protocol    = "udp"
      cidr_blocks = ["0.1.1.1/21", "8.8.8.8/24"]
    },
    {
      description = "TLS from VPC"
      from_port   = 28000
      to_port     = 28001
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    {
      description = "TLS from VPC"
      from_port   = 20
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["192.01.01.02/23"]
    }
  ]
}

module "vote_service_sg_ipv6" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_with_ipv6_cidr_blocks = [
    {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      ipv6_cidr_blocks = ["2001:db8::/32"]
    }
  ]

  egress_with_ipv6_cidr_blocks = [
    {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      ipv6_cidr_blocks = ["2001:db8::/32"]
    }
  ]
}

module "vote_service_sg_ipv6_array" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_with_ipv6_cidr_blocks = [
    {
      description      = "TLS from VPC"
      from_port        = 2383
      to_port          = 2383
      protocol         = "udp"
      ipv6_cidr_blocks = ["fd00::/8", "2001:4860:4860::8888/64"]
    },
    {
      description      = "TLS from VPC"
      from_port        = 28000
      to_port          = 28001
      protocol         = "tcp"
      ipv6_cidr_blocks = ["fc00::/7"]
    },
    {
      description      = "TLS from VPC"
      from_port        = 20
      to_port          = 22
      protocol         = "tcp"
      ipv6_cidr_blocks = ["2001:db8:abcd:0012::/64"]
    }
  ]

  egress_with_ipv6_cidr_blocks = [
    {
      description      = "TLS from VPC"
      from_port        = 2383
      to_port          = 2383
      protocol         = "udp"
      ipv6_cidr_blocks = ["fd00::/8", "2001:4860:4860::8888/64"]
    },
    {
      description      = "TLS from VPC"
      from_port        = 28000
      to_port          = 28001
      protocol         = "tcp"
      ipv6_cidr_blocks = ["fc00::/7"]
    },
    {
      description      = "TLS from VPC"
      to_port          = 22
      protocol         = "tcp"
      ipv6_cidr_blocks = ["2001:db8:abcd:0012::/64"]
    }
  ]
}