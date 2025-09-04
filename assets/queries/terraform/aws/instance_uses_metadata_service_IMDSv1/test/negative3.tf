provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "negative3" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    http_endpoint = "disabled"
    http_tokens   = "optional"
  }
}

resource "aws_launch_configuration" "negative3" {
  image_id      = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    http_endpoint = "disabled"
    http_tokens   = "optional"
  }
}