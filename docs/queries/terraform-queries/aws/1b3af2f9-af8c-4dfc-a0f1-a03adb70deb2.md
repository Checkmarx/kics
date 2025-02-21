---
title: Lambda Function With Privileged Role
hide:
  toc: true
  navigation: true
---

<style>
  .highlight .hll {
    background-color: #ff171742;
  }
  .md-content {
    max-width: 1100px;
    margin: 0 auto;
  }
</style>

-   **Query id:** 1b3af2f9-af8c-4dfc-a0f1-a03adb70deb2
-   **Query name:** Lambda Function With Privileged Role
-   **Platform:** Terraform
-   **Severity:** <span style="color:#bb2124">High</span>
-   **Category:** Insecure Configurations
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/284.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/284.html')">284</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/aws/lambda_function_with_privileged_role)

### Description
It is not advisable for AWS Lambda Functions to have privileged permissions.<br>
[Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="4 23"
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

```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
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
```
