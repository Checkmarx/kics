resource "aws_sqs_queue" "q" {
  name = "examplequeue"
}

resource "aws_sqs_queue_policy" "test" {
  queue_url = aws_sqs_queue.q.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "Queue1_Policy_UUID",
  "Statement": [{
      "Sid":"Queue1_AnonymousAccess_AllActions_AllowlistIP",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:*",
      "Resource": "arn:aws:sqs:*:111122223333:queue1",
      "Condition" : {
        "IpAddress" : {
            "aws:SourceIp":"192.168.143.0/24"
        }
      }
  }]
}
EOF
}

resource "aws_sqs_queue" "q_aws_array" {
  name = "examplequeue_aws_array"
}

resource "aws_sqs_queue" "q_aws" {
  name = "examplequeue_aws"
}

resource "aws_sqs_queue_policy" "test_aws" {
  queue_url = aws_sqs_queue.q_aws.id

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Id": "Queue1_Policy_UUID",
   "Statement": [{
      "Sid":"Queue1_AnonymousAccess_AllActions_AllowlistIP",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "sqs:*",
      "Resource": "arn:aws:sqs:*:111122223333:queue1",
      "Condition" : {
         "IpAddress" : {
            "aws:SourceIp":"192.168.143.0/24"
         }
      }
   }]
}
EOF
}

resource "aws_sqs_queue_policy" "test_aws_array" {
  queue_url = aws_sqs_queue.q_aws_array.id

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Id": "Queue1_Policy_UUID",
   "Statement": [{
      "Sid":"Queue1_AnonymousAccess_AllActions_AllowlistIP",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["*"]
      },
      "Action": "sqs:*",
      "Resource": "arn:aws:sqs:*:111122223333:queue1",
      "Condition" : {
         "IpAddress" : {
            "aws:SourceIp":"192.168.143.0/24"
         }
      }
   }]
}
EOF
}
