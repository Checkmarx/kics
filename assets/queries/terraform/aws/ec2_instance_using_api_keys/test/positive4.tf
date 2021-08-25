provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive4" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  tags = {
    Name = "test"
  }

  user_data_base64 = var.init_aws_cli

  credit_specification {
    cpu_credits = "unlimited"
  }
}
