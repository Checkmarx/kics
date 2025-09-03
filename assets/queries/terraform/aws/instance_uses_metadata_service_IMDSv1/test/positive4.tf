provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive4" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  tags = {
    Name = "positive4"
  }
}
