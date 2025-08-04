provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive3" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  metadata_options {
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name = "positive3"
  }
}
