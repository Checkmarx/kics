# "AWS Access Key" - 76c0bcde-903d-456e-ac13-e58c34987852  positive-test (line 18)
# "AWS Secret Key" - 83ab47ff-381d-48cd-bac5-fb32222f54af  positive-test (line 19)
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
