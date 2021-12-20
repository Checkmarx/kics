resource "aws_sqs_queue_policy" "positive6" {
  queue_url = aws_sqs_queue.positive1.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "aws_sqs_queue.positive1.arn"
    }
  ]
}
POLICY
}
