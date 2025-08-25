module "vote_service_sg_ipv4" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "vpc-12345678"

  ingress_with_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["172.16.0.0/12"]
    }
  ]
}

module "vote_service_sg_ipv6" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "vpc-12345678"

  ingress_with_ipv6_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      ipv6_cidr_blocks = ["fc00::/7"]
    }
  ]
}

module "vote_service_sg_ipv4_array" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "vpc-12345678"

  ingress_with_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 2383
      to_port     = 2383
      protocol    = "udp"
      cidr_blocks = ["192.168.0.0/16", "10.0.0.0/8"]
    },
    {
      description = "TLS from VPC"
      from_port   = 28000
      to_port     = 28001
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    },
    {
      description = "TLS from VPC"
      from_port   = 20
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }
  ]
}

module "vote_service_sg_ipv6_array" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "vpc-12345678"

  ingress_with_ipv6_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 2383
      to_port     = 2383
      protocol    = "udp"
      ipv6_cidr_blocks = ["fc00::/7", "2401:fa00:4:1a::abcd/128"]
    },
    {
      description = "TLS from VPC"
      from_port   = 28000
      to_port     = 28001
      protocol    = "tcp"
      ipv6_cidr_blocks = ["2606:4700:3033::6815:3e3/56"]
    },
    {
      description = "TLS from VPC"
      from_port   = 20
      to_port     = 22
      protocol    = "tcp"
      ipv6_cidr_blocks = ["fc00::/7"]
    }
  ]
}