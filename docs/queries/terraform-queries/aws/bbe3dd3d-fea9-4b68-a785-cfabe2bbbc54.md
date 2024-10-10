---
title: Policy Without Principal
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

-   **Query id:** bbe3dd3d-fea9-4b68-a785-cfabe2bbbc54
-   **Query name:** Policy Without Principal
-   **Platform:** Terraform
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Access Control
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/284.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/284.html')">284</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/aws/policy_without_principal)

### Description
All policies, except IAM identity-based policies, should have the 'Principal' element defined<br>
[Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="9"
provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "secure_policy" {
  description             = "KMS key + secure_policy"
  deletion_window_in_days = 7

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "Secure Policy",
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
            "kms:Create*",
            "kms:Describe*",
            "kms:Enable*",
            "kms:List*",
            "kms:Put*",
            "kms:Update*",
            "kms:Revoke*",
            "kms:Disable*",
            "kms:Get*",
            "kms:Delete*",
            "kms:TagResource",
            "kms:UntagResource",
            "kms:ScheduleKeyDeletion",
            "kms:CancelKeyDeletion"
            ]
        }
    ]
}
EOF
}

```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "secure_policy" {
  description             = "KMS key + secure_policy"
  deletion_window_in_days = 7

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "Secure Policy",
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
            "kms:Create*",
            "kms:Describe*",
            "kms:Enable*",
            "kms:List*",
            "kms:Put*",
            "kms:Update*",
            "kms:Revoke*",
            "kms:Disable*",
            "kms:Get*",
            "kms:Delete*",
            "kms:TagResource",
            "kms:UntagResource",
            "kms:ScheduleKeyDeletion",
            "kms:CancelKeyDeletion"
            ],
            "Principal": "AWS": [
              "arn:aws:iam::AWS-account-ID:user/user-name-1",
              "arn:aws:iam::AWS-account-ID:user/UserName2"
            ]
        }
    ]
}
EOF
}

```
```tf title="Negative test num. 2 - tf file"
resource "aws_iam_user" "user" {
  name = "test-user"
}

resource "aws_iam_role" "role" {
  name = "test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_group" "group" {
  name = "test-group"
}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"

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

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  users      = [aws_iam_user.user.name]
  roles      = [aws_iam_role.role.name]
  groups     = [aws_iam_group.group.name]
  policy_arn = aws_iam_policy.policy.arn
}

```
```tf title="Negative test num. 3 - tf file"
data "aws_iam_policy_document" "glue-example-policyX" {
  statement {
    actions = [
      "glue:CreateTable",
    ]
    resources = ["arn:data.aws_partition.current.partition:glue:data.aws_region.current.name:data.aws_caller_identity.current.account_id:*"]
    principals {
      identifiers = ["arn:aws:iam::var.account_id:saml-provider/var.provider_name"]
      type        = "AWS"
    }
  }
}

resource "aws_glue_resource_policy" "exampleX" {
  policy = data.aws_iam_policy_document.glue-example-policyX.json
}

```
<details><summary>Negative test num. 4 - tf file</summary>

```tf
data "aws_iam_policy_document" "example" {
  statement {
    actions = [
      "cloudwatch:PutMetricData",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "example" {
  name               = "example-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json

  inline_policy {
    name   = "default"
    policy = data.aws_iam_policy_document.example.json
  }
}
```
</details>
