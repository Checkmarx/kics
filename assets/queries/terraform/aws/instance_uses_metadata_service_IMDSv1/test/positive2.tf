provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive2" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  tags = {
    Name = "positive2"
  }
}
