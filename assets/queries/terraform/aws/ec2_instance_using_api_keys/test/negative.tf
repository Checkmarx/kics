provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role_policy_attachment" "test_attach" {
  roles      = [aws_iam_role.test_role.name]
  policy_arn = aws_iam_policy.test_policy.arn
}

resource "aws_iam_policy" "test_policy" {
  name = "test_policy"
  description = "test policy"
  path = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": [
              "s3:Get*",
              "s3:List*"
          ],
          "Effect": "Allow",
          "Resource": "*"
      }
  ]
}
EOF
}

resource "aws_iam_role" "test_role" {
  name = "test_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.role.name
}

resource "aws_instance" "negative1" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  tags = {
    Name = "test"
  }

  iam_instance_profile = aws_iam_instance_profile.test_profile.name

  credit_specification {
    cpu_credits = "unlimited"
  }
}
