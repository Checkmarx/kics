module "negative_4_ipv4" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_cidr_blocks = ["10.10.0.0/16"]
}

module "negative_4_ipv4_array" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_cidr_blocks = ["10.10.2.0/16", "192.12.0.1/20"]
}

module "negative_4_ipv6" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_ipv6_cidr_blocks  = ["fc00::/8"]
}

module "negative_4_ipv6_array" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_ipv6_cidr_blocks  = ["fc00::/8", "fd00::/12"]
}

module "negative_4_whole_ingresses" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_with_cidr_blocks = [
    {
      description = "Allow HTTP from internal IPv4 network"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.10.0.0/16"]
    },
    {
      description = "Allow HTTP from internal IPv4 network"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.10.2.0/16", "192.12.0.1/20"]
    }
  ]

  ingress_with_ipv6_cidr_blocks = [
    {
      description      = "Allow HTTP from internal IPv6 network"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      ipv6_cidr_blocks = ["fc00::/8"]
    },
    {
      description      = "Allow HTTP from internal IPv6 network"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      ipv6_cidr_blocks = ["fc00::/8", "fd00::/12"]
    }
  ]
}