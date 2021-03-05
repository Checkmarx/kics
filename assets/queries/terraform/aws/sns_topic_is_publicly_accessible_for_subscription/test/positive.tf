resource "aws_sns_topic" "sns_topic" {
policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
{
"Action": "*",
"Principal": {
  "AWS": "*"
},
"Effect": "Allow",
"Sid": ""
}
]
}
EOF
}
