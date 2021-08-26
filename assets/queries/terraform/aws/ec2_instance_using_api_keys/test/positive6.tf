provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive6" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  tags = {
    Name = "test"
  }

  user_data = <<EOT
#cloud-config
repo_update: true
repo_upgrade: all

packages:
 - awscli

runcmd:
 - [ sh, -c, "echo export AWS_ACCESS_KEY_ID=my-key-id >> ~/.bashrc" ]
 - [ sh, -c, "echo export AWS_SECRET_ACCESS_KEY=my-secret >> ~/.bashrc" ]
EOT

  credit_specification {
    cpu_credits = "unlimited"
  }
}
