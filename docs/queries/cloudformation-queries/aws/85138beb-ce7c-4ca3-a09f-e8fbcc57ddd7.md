---
title: Cross-Account IAM Assume Role Policy Without ExternalId or MFA
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

-   **Query id:** 85138beb-ce7c-4ca3-a09f-e8fbcc57ddd7
-   **Query name:** Cross-Account IAM Assume Role Policy Without ExternalId or MFA
-   **Platform:** CloudFormation
-   **Severity:** <span style="color:#bb2124">High</span>
-   **Category:** Access Control
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/284.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/284.html')">284</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/cloudFormation/aws/cross_account_iam_assume_role_policy_without_external_id_or_mfa)

### Description
Cross-Account IAM Assume Role Policy should require external ID or MFA to protect cross-account access<br>
[Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html#cfn-iam-role-assumerolepolicydocument)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="6"
AWSTemplateFormatVersion: "2010-09-09"
Resources:
  RootRole:
    Type: "AWS::IAM::Role"
    Properties:
      AssumeRolePolicyDocument: >
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Action": "sts:AssumeRole",
              "Principal": {
                "AWS": "arn:aws:iam::987654321145:root"
              },
              "Effect": "Allow",
              "Resource": "*",
              "Sid": ""
            }
          ]
        }

```
```json title="Positive test num. 2 - json file" hl_lines="7"
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "RootRole": {
      "Type": "AWS::IAM::Role",
      "Properties": {
        "AssumeRolePolicyDocument": {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Action": "sts:AssumeRole",
              "Principal": {
                "AWS": "arn:aws:iam::987654321145:root"
              },
              "Effect": "Allow",
              "Resource": "*",
              "Sid": ""
            }
          ]
        },
        "Path": "/"
      }
    }
  }
}

```
```yaml title="Positive test num. 3 - yaml file" hl_lines="6"
AWSTemplateFormatVersion: "2010-09-09"
Resources:
  RootRole:
    Type: "AWS::IAM::Role"
    Properties:
      AssumeRolePolicyDocument: >
        {
          "Version": "2012-10-17",
          "Statement": {
                "Action": "sts:AssumeRole",
                "Principal": {
                  "AWS": "arn:aws:iam::987654321145:root"
                },
                "Effect": "Allow",
                "Resource": "*",
                "Sid": "",
                "Condition": { 
                  "Bool": { 
                      "aws:MultiFactorAuthPresent": "false" 
                    }
                }
          }
        }

```
<details><summary>Positive test num. 4 - json file</summary>

```json hl_lines="7"
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "RootRole": {
      "Type": "AWS::IAM::Role",
      "Properties": {
        "AssumeRolePolicyDocument": {
          "Version": "2012-10-17",
          "Statement": {
            "Action": "sts:AssumeRole",
            "Principal": {
              "AWS": "arn:aws:iam::987654321145:root"
            },
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "",
            "Condition": { 
              "Bool": { 
                  "aws:MultiFactorAuthPresent": "false" 
                }
            }
          }
        },
        "Path": "/"
      }
    }
  }
}

```
</details>
<details><summary>Positive test num. 5 - yaml file</summary>

```yaml hl_lines="6"
AWSTemplateFormatVersion: "2010-09-09"
Resources:
  RootRole:
    Type: "AWS::IAM::Role"
    Properties:
      AssumeRolePolicyDocument: >
        {
          "Version": "2012-10-17",
          "Statement": {
              "Action": "sts:AssumeRole",
              "Principal": {
                "AWS": "arn:aws:iam::987654321145:root"
              },
              "Effect": "Allow",
              "Resource": "*",
              "Sid": "",
              "Condition": {
                "StringEquals": {
                  "sts:ExternalId": ""
                }
              }
          }
        }

```
</details>
<details><summary>Positive test num. 6 - json file</summary>

```json hl_lines="7"
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "RootRole": {
      "Type": "AWS::IAM::Role",
      "Properties": {
        "AssumeRolePolicyDocument": {
          "Version": "2012-10-17",
          "Statement": {
            "Action": "sts:AssumeRole",
            "Principal": {
              "AWS": "arn:aws:iam::987654321145:root"
            },
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "",
            "Condition": {
              "StringEquals": {
                "sts:ExternalId": ""
              }
            }
          }
        },
        "Path": "/"
      }
    }
  }
}

```
</details>


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
AWSTemplateFormatVersion: "2010-09-09"
Resources:
  RootRole:
    Type: "AWS::IAM::Role"
    Properties:
      AssumeRolePolicyDocument: >
        {
            "Version": "2012-10-17",
            "Statement": [
              {
                "Action": "sts:AssumeRole",
                "Principal": {
                  "AWS": "arn:aws:iam::987654321145:root"
                },
                "Effect": "Allow",
                "Resource": "*",
                "Sid": "",
                "Condition": {
                  "StringEquals": {
                    "sts:ExternalId": "98765"
                  }
                }
              }
            ]
        }

```
```json title="Negative test num. 2 - json file"
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "RootRole": {
      "Type": "AWS::IAM::Role",
      "Properties": {
        "AssumeRolePolicyDocument": {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Action": "sts:AssumeRole",
              "Principal": {
                "AWS": "arn:aws:iam::987654321145:root"
              },
              "Effect": "Allow",
              "Resource": "*",
              "Sid": "",
              "Condition": {
                "StringEquals": {
                  "sts:ExternalId": "98765"
                }
              }
            }
          ]
        },
        "Path": "/"
      }
    }
  }
}

```
```yaml title="Negative test num. 3 - yaml file"
AWSTemplateFormatVersion: "2010-09-09"
Resources:
  RootRole:
    Type: "AWS::IAM::Role"
    Properties:
      AssumeRolePolicyDocument: >
        {
            "Version": "2012-10-17",
            "Statement": [
              {
                "Action": "sts:AssumeRole",
                "Principal": {
                  "AWS": "arn:aws:iam::987654321145:root"
                },
                "Effect": "Allow",
                "Resource": "*",
                "Sid": "",
                "Condition": { 
                  "Bool": { 
                      "aws:MultiFactorAuthPresent": "true" 
                    }
                }
              }
            ]
        }

```
<details><summary>Negative test num. 4 - json file</summary>

```json
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "RootRole": {
      "Type": "AWS::IAM::Role",
      "Properties": {
        "AssumeRolePolicyDocument": {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Action": "sts:AssumeRole",
              "Principal": {
                "AWS": "arn:aws:iam::987654321145:root"
              },
              "Effect": "Allow",
              "Resource": "*",
              "Sid": "",
              "Condition": { 
                "Bool": { 
                    "aws:MultiFactorAuthPresent": "true" 
                  }
              }
            }
          ]
        },
        "Path": "/"
      }
    }
  }
}

```
</details>
