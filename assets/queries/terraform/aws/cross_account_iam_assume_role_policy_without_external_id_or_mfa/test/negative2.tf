resource "aws_iam_role" "negative2" {
  name = "test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::987654321145:root"
      },
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "",
      "Condition": { 
         "Bool": { 
            "aws:MultiFactorAuthPresent": "true" 
          }
      }
    }
  ]
}
EOF

  tags = {
    tag-key = "tag-value"
  }
}
