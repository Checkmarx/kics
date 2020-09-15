resource "aws_sqs_queue" "q" {
  name = "examplequeue"
}

resource "aws_sqs_queue_policy" "test" {
  queue_url = aws_sqs_queue.q.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "*",
      "Resource": "${aws_sqs_queue.q.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.example.arn}"
        }
      }
    }
  ]
}
POLICY
}