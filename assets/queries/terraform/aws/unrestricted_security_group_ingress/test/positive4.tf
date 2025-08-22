module "positive_4_ipv4" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "positive_4_ipv4_array" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_cidr_blocks = ["10.10.0.0/16", "0.0.0.0/0"]
}

module "positive_4_ipv6" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_ipv6_cidr_blocks  = ["::/0"]
}

module "positive_4_ipv6_array" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_ipv6_cidr_blocks  = ["fc00::/8", "::/0"]
}

module "positive_4_whole_ingresses" {
  source  = "terraform-aws-modules/security-group/aws"

  ingress_with_cidr_blocks = [
    {
      description = "Allow HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTP from internal network"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.10.0.0/16"]
    },
    {
      description = "Allow HTTP from internal network"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.10.0.0/16","0.0.0.0/0"]
    }
  ]

  ingress_with_ipv6_cidr_blocks = [
    {
      description      = "Allow HTTP from all IPv6 addresses"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Allow HTTP from internal IPv6 range"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      ipv6_cidr_blocks = ["fc00::/8"]
    },
    {
      description      = "Allow HTTP from internal IPv6 range"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      ipv6_cidr_blocks = ["fc00::/8","::/0"]
    }
  ]
}