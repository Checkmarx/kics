module "negative4_ipv4_1" {
  source  = "terraform-aws-modules/security-group/aws"
  ingress_with_cidr_blocks = [
    {
      #incorrect protocol
      from_port   = 22
      to_port     = 22
      protocol    = "icmp"
      cidr_blocks = ["10.0.0.0/0"]
    },
    {
      #incorrect port range (unknown)
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      cidr_blocks = ["192.168.0.0/0"]
    },
    {
      #incorrect cidr (mask is not "/0")
      from_port   = 22
      to_port     = 22
      protocol    = "udp"
      cidr_blocks = ["8.8.0.0/16"]
    },
    {
      #all incorrect 
      from_port   = 5000
      to_port     = 5000
      protocol    = "icmp"
      cidr_blocks = ["10.68.0.0/14", "8.8.0.0/16"]
    }
  ]
}

module "negative4_ipv6_1" {
  source  = "terraform-aws-modules/security-group/aws"
  ingress_with_ipv6_cidr_blocks = [
    {
      #incorrect protocol
      from_port         = 22
      to_port           = 22
      protocol          = "icmpv6"
      ipv6_cidr_blocks  = ["fd00::/0"] 
    },
    {
      #incorrect port range (unknown)
      from_port         = 5000
      to_port           = 5000
      protocol          = "tcp"
      ipv6_cidr_blocks  = ["fd12:3456:789a::1/0"]  
    },
    {
      #incorrect cidr (mask is not "/0")
      from_port         = 22
      to_port           = 22
      protocol          = "udp"
      ipv6_cidr_blocks  = ["2400:cb00::/32"] 
    },
    {
      #all incorrect
      from_port         = 5000
      to_port           = 5000
      protocol          = "icmpv6"
      ipv6_cidr_blocks  = ["fd03:5678::/64", "2400:cb00::/32"] 
    }
  ]
}
