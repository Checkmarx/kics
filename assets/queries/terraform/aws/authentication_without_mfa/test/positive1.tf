provider "aws" {
  region  = "us-east-1"
}

resource "aws_iam_user" "positive1" {
  name = "aws-foundations-benchmark-1-4-0-terraform-user"
  path = "/"
}

resource "aws_iam_user_login_profile" "positive1" {
  user = aws_iam_user.positive1.name
  pgp_key = "gpgkeybase64gpgkeybase64gpgkeybase64gpgkeybase64"
}

resource "aws_iam_access_key" "positive1" {
  user = aws_iam_user.positive1.name
}

resource "aws_iam_user_policy" "positive1" {
  name = "aws-foundations-benchmark-1-4-0-terraform-user"
  user = aws_iam_user.positive1.name

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Effect": "Allow",
       "Resource": "${aws_iam_user.positive1.arn}",
       "Action": "sts:AssumeRole",
       "Condition": {
         "BoolIfExists": {
           "aws:MultiFactorAuthPresent" : "false"
         }
       }
     }
   ]
}
EOF
}
