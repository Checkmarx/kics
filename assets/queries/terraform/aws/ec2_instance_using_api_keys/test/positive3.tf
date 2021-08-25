provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive3" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  tags = {
    Name = "test"
  }

  user_data = <<EOT
#!/bin/bash
apt-get install -y awscli
cat << EOF > ~/.aws/credentials
[default]
aws_access_key_id = somekey
aws_secret_access_key = somesecret
EOF
EOT

  credit_specification {
    cpu_credits = "unlimited"
  }
}
