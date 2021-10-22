resource "aws_sqs_queue" "positive2" {
  name                      = "terraform-example-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
    maxReceiveCount     = 4
  })

  tags = {
    Environment = "production"
  }
}


resource "aws_sqs_queue_policy" "positive2" {
  queue_url = aws_sqs_queue.positive2.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal" : { 
        "AWS": [ 
          "arn:aws:iam::123456789012:root",
          "arn:aws:iam::555555555555:root" 
          ]
      },
      "Action": "sqs:SendMessage",
      "Resource": "aws_sqs_queue.positive2.arn"
    }
  ]
}
POLICY
}
