---
title: IAM Role Policy passRole Allows All
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

-   **Query id:** e39bee8c-fe54-4a3f-824d-e5e2d1cca40a
-   **Query name:** IAM Role Policy passRole Allows All
-   **Platform:** Terraform
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Access Control
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/284.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/284.html')">284</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/aws/iam_role_policy_passrole_allows_all)

### Description
Using the iam:passrole action with wildcards (*) in the resource can be overly permissive because it allows iam:passrole permissions on multiple resources<br>
[Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-reference-policy-checks.html#access-analyzer-reference-policy-checks-security-warning-pass-role-with-star-in-resource)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="5"
resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "iam:passrole"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}




```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "iam:passrole"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:sqs:us-east-2:account-ID-without-hyphens:queue1"
      }
    ]
  }
  EOF
}


```
