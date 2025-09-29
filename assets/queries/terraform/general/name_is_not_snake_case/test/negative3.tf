# These should NOT be flagged - legitimate exceptions

# Short names (4 chars or less)
resource "aws_s3_bucket" "app" {
  bucket = "my-app-bucket"
}

# Common abbreviations
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "sg" {
  name = "my-security-group"
}

resource "aws_db_instance" "rds" {
  engine = "mysql"
}

# Single words up to 10 characters
resource "aws_instance" "webserver" {
  ami = "ami-12345"
}

resource "aws_lambda_function" "processor" {
  function_name = "data-processor"
}

# Version identifiers
resource "aws_instance" "webv1" {
  ami = "ami-12345"
}

resource "aws_lambda_function" "apiv2" {
  function_name = "api-v2"
}

# External modules should not be flagged
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "my-vpc"
}

module "security-group" {
  source = "github.com/terraform-aws-modules/terraform-aws-security-group"
  name   = "web-sg"
}

# Resources with external naming requirements should not be flagged
resource "aws_route53_record" "www-example-com" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.example.com"
  type    = "A"
}

resource "aws_acm_certificate" "example-com" {
  domain_name = "example.com"
}
