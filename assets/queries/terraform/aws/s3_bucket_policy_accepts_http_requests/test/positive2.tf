resource "aws_s3_bucket" "b2" {
  bucket = "my-tf-test-bucket"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "MYBUCKETPOLICY",
    "Statement": [
      {
        "Sid": "IPAllow",
        "Effect": "Deny",
        "Principal": "*",
        "Action": "s3:*",
        "Resource": [
          "aws_s3_bucket.b.arn"
        ],
        "Condition": {
          "IpAddress": {
            "aws:SourceIp": "8.8.8.8/32"
          }
        }
      }
    ]
}
EOF
}
