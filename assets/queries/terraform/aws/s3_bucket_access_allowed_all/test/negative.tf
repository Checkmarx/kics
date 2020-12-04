#this code is a correct code for which the query should not find any result
resource "aws_s3_bucket" "b" {
  bucket = "my_tf_test_bucket"

    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "IPDeny",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::my_tf_test_bucket/*",
    }
  ]
}
POLICY
}