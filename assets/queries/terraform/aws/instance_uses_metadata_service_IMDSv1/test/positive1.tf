provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive1_1" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    http_tokens   = "optional"
  }
}

resource "aws_launch_configuration" "positive1_2" {
  image_id      = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    http_tokens   = "optional"
  }
}

resource "aws_launch_template" "positive1_3" {
  image_id      = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    http_tokens   = "optional"
  }
}
