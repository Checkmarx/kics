# Cases that should NOT be flagged by the improved rule

# Single word names are acceptable
resource "aws_instance" "web" {
  ami = "ami-12345"
  instance_type = "t2.micro"
}

resource "aws_instance" "app" {
  ami = "ami-12345"
  instance_type = "t2.micro"
}

# Common abbreviations are widely accepted
resource "aws_security_group" "sg" {
  name = "my-sg"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_lb" "lb" {
  name = "my-lb"
}

resource "aws_rds_instance" "rds" {
  identifier = "my-rds"
}

resource "aws_s3_bucket" "s3" {
  bucket = "my-bucket"
}

# Very short names (≤4 chars) are acceptable
resource "aws_instance" "api" {
  ami = "ami-12345"
}

resource "aws_instance" "db" {
  ami = "ami-12345"
}

# External modules should not be flagged
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"
  name = "my-vpc"
}

module "acm" {
  source = "terraform-aws-modules/acm/aws"
  version = "~> v2.0"
  domain_name = "example.com"
}

# Git modules should not be flagged
module "myModule" {
  source = "git::https://example.com/vpc.git"
}

# HTTP modules should not be flagged
module "httpModule" {
  source = "https://example.com/modules/vpc.zip"
}

# Names with version identifiers
resource "aws_instance" "appv1" {
  ami = "ami-12345"
}

resource "aws_instance" "apiv2" {
  ami = "ami-12345"
}

# Resources with external naming requirements should not be flagged
resource "aws_route53_record" "exampleCom" {
  zone_id = "Z123456789"
  name    = "example.com"
  type    = "A"
}

resource "aws_acm_certificate" "exampleCom" {
  domain_name = "example.com"
}

# Kubernetes resources often follow different conventions
resource "kubernetes_namespace" "myNamespace" {
  metadata {
    name = "my-namespace"
  }
}
