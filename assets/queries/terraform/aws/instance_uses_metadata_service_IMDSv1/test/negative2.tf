provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "negative2" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    http_tokens   = "required"
  }
}

resource "aws_launch_configuration" "negative2" {
  image_id      = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    http_tokens   = "required"
  }
}
