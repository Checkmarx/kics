resource "aws_sns_topic" "positive1" {
  name = "my-topic-with-policy"
}

resource "aws_sns_topic_policy" "positive2" {
  arn = aws_sns_topic.test.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYPOLICYTEST",
  "Statement": [
    {
      "NotAction": "s3:DeleteBucket",
      "Resource": "arn:aws:s3:::*",
      "Sid": "MyStatementId",
      "Effect": "Allow"
    }
  ]
}
POLICY
}
