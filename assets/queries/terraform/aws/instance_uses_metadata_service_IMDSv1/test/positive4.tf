provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive4_1" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}

resource "aws_launch_configuration" "positive4_2" {
  image_id      = "ami-12345678"
  instance_type = "t2.micro"
}

resource "aws_launch_template" "positive4_3" {
  image_id      = "ami-12345678"
  instance_type = "t2.micro"
}
