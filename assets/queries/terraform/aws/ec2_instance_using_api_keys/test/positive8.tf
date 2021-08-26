provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive8" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  tags = {
    Name = "test"
  }

  provisioner "file" {
    source      = "conf/aws-credentials"
    destination = "~/.aws/credentials"
  }
}
