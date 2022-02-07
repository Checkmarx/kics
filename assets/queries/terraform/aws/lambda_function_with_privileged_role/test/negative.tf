resource "aws_lambda_function" "negativefunction1" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.negativerole1.arn
  handler       = "exports.test"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
  runtime = "nodejs12.x"

  tags = {
    Name = "lambda"
  }

  environment = {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_function" "negativefunction2" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.negativerole2.arn
  handler       = "exports.test"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
  runtime = "nodejs12.x"

  tags = {
    Name = "lambda"
  }

  environment = {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_iam_role" "negativerole1" {
  name = "negativerole1"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["some:action"],
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Resource": "*",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role" "negativerole2" {
  name = "negativerole2"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["some:action"],
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Resource": "*",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    tag-key = "tag-value"
  }
}


resource "aws_iam_role_policy" "negativeinlinepolicy1" {
  name = "negativeinlinepolicy1"
  role = aws_iam_role.negativerole1.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "negativecustomermanagedpolicy1" {
  name        = "negativecustomermanagedpolicy1"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "negativecustomermanagedpolicy2" {
  name        = "negativecustomermanagedpolicy2"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:CreateFunction"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Mapping of customer managed policy defined in this template set
resource "aws_iam_role_policy_attachment" "negativerolepolicyattachment1" {
  role       = aws_iam_role.negativerole1.name
  policy_arn = aws_iam_policy.negativecustomermanagedpolicy1.arn
}

resource "aws_iam_policy_attachment" "negativedirectpolicyattachment1" {
  roles       = [aws_iam_role.negativerole1.name]
  policy_arn = aws_iam_policy.negativecustomermanagedpolicy2.arn
}

# Mapping of pre-existing policy arns
resource "aws_iam_role_policy_attachment" "negativerolepolicyattachment2" {
  role       = aws_iam_role.negativerole2.name
  policy_arn = "arn:aws:iam::policy/negativepreexistingpolicyarn1"
}

resource "aws_iam_policy_attachment" "negativedirectpolicyattachment2" {
  roles       = [aws_iam_role.negativerole2.name]
  policy_arn = "arn:aws:iam::policy/DenyAll"
}