provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive3_1" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    instance_metadata_tags = "enabled"
  }
}

resource "aws_launch_configuration" "positive3_2" {
  image_id      = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    instance_metadata_tags = "enabled"
  }
}

resource "aws_launch_template" "positive3_3" {
  image_id      = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    instance_metadata_tags = "enabled"
  }
}
