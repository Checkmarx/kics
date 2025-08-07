provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive5" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    http_endpoint = "enabled"
  }

  tags = {
    Name = "positive5"
  }
}
