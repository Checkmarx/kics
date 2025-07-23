provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive3" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    http_endpoint = "disabled"
    http_tokens = "required"
  }

  tags = {
    Name = "positive3"
  }
}