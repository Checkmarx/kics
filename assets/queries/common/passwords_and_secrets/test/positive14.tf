
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive1" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  tags = {
    Name = "test"
  }

  user_data = <<EOF
#!/bin/bash
apt-get install -y awscli
export AWS_ACCESS_KEY_ID=AKIASXANV9XVIJ1YCIJ5
export AWS_SECRET_ACCESS_KEY=ZH6HDV/EolIbS2UTxbLplGpukOdaGmlq9MtAg1Xv
EOF

  credit_specification {
    cpu_credits = "unlimited"
  }
}
