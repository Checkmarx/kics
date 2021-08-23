provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive9" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  tags = {
    Name = "test"
  }

  provisioner "remote-exec" {
    inline = [
      "echo export AWS_ACCESS_KEY_ID=my-key-id >> ~/.bashrc",
      "echo export AWS_SECRET_ACCESS_KEY=my-secret >> ~/.bashrc"
    ]
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}
