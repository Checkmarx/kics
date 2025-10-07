module "vote_service_sg_ipv4" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "vpc-12345678"

  ingress_with_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["1.2.3.4"]
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
      from_port   = 0
      to_port     = 0
      protocol    = "tcp"
      ipv6_cidr_blocks = ["2001:0db8:85a3:0000:0000:8a2e:0370:7334/64"]
    }
  ]
}

module "vote_service_sg_ipv4_port_22_not_covered" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "vpc-12345678"

  ingress_with_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 30
      to_port     = 2000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0"]
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
      from_port   = 22
      to_port     = 22
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0", "8.8.8.8/24"]
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

module "vote_service_sg_ipv6_array" {
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
      protocol    = "udp"
      ipv6_cidr_blocks = ["2001:0db8:85a3::8a2e:0370:7334/64", "::/0"]
    },
    {
      description = "TLS from VPC"
      from_port   = 28000
      to_port     = 28001
      protocol    = "tcp"
      ipv6_cidr_blocks = ["10.0.0.0/16"]
    },
    {
      description = "TLS from VPC"
      from_port   = 20
      to_port     = 22
      protocol    = "tcp"
      ipv6_cidr_blocks = ["2606:4700:3033::6815:3e3/56"]
    },
    {
      description = "TLS from VPC"
      from_port   = 28000
      to_port     = 28001
      protocol    = "tcp"
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}