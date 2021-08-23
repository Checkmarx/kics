provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive7" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  tags = {
    Name = "test"
  }

  provisioner "remote-exec" {
    inline = [
      "wget -O - http://config.remote.server.com/aws-credentials > ~/.aws/credentials;"
    ]
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}
