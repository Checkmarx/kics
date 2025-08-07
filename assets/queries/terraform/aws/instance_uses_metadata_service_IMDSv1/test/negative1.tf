provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "negative1" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "negative1"
  }
}
