resource "aws_iam_user" "positive1" {
  name = "root"
  path = "/system/"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_access_key" "positive2" {
  user = aws_iam_user.lb.name
}

resource "aws_iam_user_policy" "positive3" {
  name = "test"
  user = aws_iam_user.lb.name

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Effect": "Allow",
       "Principal": {
         "AWS": "arn:aws:iam::111122223333:root"
       },
       "Action": "sts:AssumeRole"
     }
   ]
}
EOF
}