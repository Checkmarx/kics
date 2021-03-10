resource "aws_organizations_policy" "positive1" {
  name = "example"

  content = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect": "Allow",
        "Action": "iam",
        "Resource": "*"
        }
    ]
}
CONTENT
}

resource "aws_organizations_policy" "positive2" {
  name = "example"
  type = "SERVICE_CONTROL_POLICY"
  content = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "*",
    "Resource": ["some-resource"]
  }
}
CONTENT
}

resource "aws_organizations_policy" "positive3" {
  name = "example"

  content = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Deny",
    "Action": "*",
    "Resource": "*"
  }
}
CONTENT
}
