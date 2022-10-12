resource "aws_lambda_function" "positivefunction1" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.positiverole1.arn
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

resource "aws_lambda_function" "positivefunction2" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.positiverole2.arn
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

resource "aws_iam_role" "positiverole1" {
  name = "positiverole1"

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

resource "aws_iam_role" "positiverole2" {
  name = "positiverole2"

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


resource "aws_iam_role_policy" "positiveinlinepolicy1" {
  name = "positiveinlinepolicy1"
  role = aws_iam_role.positiverole1.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
          "iam:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "positivecustomermanagedpolicy1" {
  name        = "positivecustomermanagedpolicy1"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "iam:CreateLoginProfile"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "positivecustomermanagedpolicy2" {
  name        = "positivecustomermanagedpolicy2"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Mapping of customer managed policy defined in this template set
resource "aws_iam_role_policy_attachment" "positiverolepolicyattachment1" {
  role       = aws_iam_role.positiverole1.name
  policy_arn = aws_iam_policy.positivecustomermanagedpolicy1.arn
}

resource "aws_iam_policy_attachment" "positivedirectpolicyattachment1" {
  roles       = [aws_iam_role.positiverole1.name]
  policy_arn = aws_iam_policy.positivecustomermanagedpolicy2.arn
}

# Mapping of pre-existing policy arns
resource "aws_iam_role_policy_attachment" "positiverolepolicyattachment2" {
  role       = aws_iam_role.positiverole2.name
  policy_arn = "arn:aws:iam::policy/positivepreexistingpolicyarn1"
}

resource "aws_iam_policy_attachment" "positivedirectpolicyattachment2" {
  roles       = [aws_iam_role.positiverole2.name]
  policy_arn = "arn:aws:iam::policy/AmazonPersonalizeFullAccess"
}
