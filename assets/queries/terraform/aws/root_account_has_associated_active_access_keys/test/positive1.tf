#this is a problematic code where the query should report a result(s)
resource "aws_iam_access_key" "positive1" {
  user    = "root"
  pgp_key = "keybase:some_person_that_exists"
}

resource "aws_iam_user" "positive3" {
  name = "loadbalancer"
  path = "/system/"
}

resource "aws_iam_user_policy" "positive4" {
  name = "test"
  user = aws_iam_user.lb.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

output "secret" {
  value = aws_iam_access_key.lb.encrypted_secret
}
