provider "aws" {
  region  = "us-east-1"
}

resource "aws_iam_user" "negative1" {
  name = "aws-foundations-benchmark-1-4-0-terraform-user"
  path = "/"
}

resource "aws_iam_user_login_profile" "negative1" {
  user = aws_iam_user.negative1.name
  pgp_key = "gpgkeybase64gpgkeybase64gpgkeybase64gpgkeybase64"
}

resource "aws_iam_access_key" "negative1" {
  user = aws_iam_user.negative1.name
}

resource "aws_iam_user_policy" "negative1" {
  name = "aws-foundations-benchmark-1-4-0-terraform-user"
  user = aws_iam_user.negative1.name

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Effect": "Allow",
       "Resource": ${aws_iam_user.negative1.arn},
       "Action": "sts:AssumeRole",
       "Condition": {
         "BoolIfExists": {
           "aws:MultiFactorAuthPresent" : "true"
         }
       }
     }
   ]
}
EOF
}
