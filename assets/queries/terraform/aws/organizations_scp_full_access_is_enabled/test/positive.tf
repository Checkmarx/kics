resource "aws_organizations_policy" "not_all_actions_allowed" {
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

resource "aws_organizations_policy" "not_all_resources_allowed" {
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

resource "aws_organizations_policy" "all_features_denied" {
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
