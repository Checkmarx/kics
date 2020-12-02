#this is a problematic code where the query should report a result(s)
resource "aws_s3_bucket" "b" {
  bucket = "my_tf_test_bucket"

    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::my_tf_test_bucket/*"
    }
  ]
}
POLICY
}