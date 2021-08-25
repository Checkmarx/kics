provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive5" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  tags = {
    Name = "test"
  }

  user_data_base64 = base64encode("apt-get install -y awscli; export AWS_ACCESS_KEY_ID=your_access_key_id_here; export AWS_SECRET_ACCESS_KEY=your_secret_access_key_here")

  credit_specification {
    cpu_credits = "unlimited"
  }
}
