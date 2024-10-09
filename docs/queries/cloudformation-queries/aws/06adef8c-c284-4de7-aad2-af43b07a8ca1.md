---
title: IAM User LoginProfile Password Is In Plaintext
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

-   **Query id:** 06adef8c-c284-4de7-aad2-af43b07a8ca1
-   **Query name:** IAM User LoginProfile Password Is In Plaintext
-   **Platform:** CloudFormation
-   **Severity:** <span style="color:#bb2124">High</span>
-   **Category:** Secret Management
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/256.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/256.html')">256</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/cloudFormation/aws/iam_user_login_profile_password_is_in_plaintext)

### Description
IAM User LoginProfile Password must not be a plaintext string<br>
[Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-iam-user.html)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="9"
AWSTemplateFormatVersion: "2010-09-09"
Description: A sample template
Resources:
    myuser:
      Type: AWS::IAM::User
      Properties:
        Path: "/"
        LoginProfile:
         Password: myP@ssW0rd
         PasswordResetRequired: false
        Policies:
        - PolicyName: giveaccesstoqueueonly
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
            - Effect: Allow
              Action:
              - sqs:*
              Resource:
              - !GetAtt myqueue.Arn
            - Effect: Deny
              Action:
              - sqs:*
              NotResource:
              - !GetAtt myqueue.Arn

```
```json title="Positive test num. 2 - json file" hl_lines="9"
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "A sample template",
  "Resources": {
    "myuser": {
      "Type": "AWS::IAM::User",
      "Properties": {
        "LoginProfile": {
          "Password": "myP@ssW0rd",
          "PasswordResetRequired": false
        },
        "Policies": [
          {
            "PolicyName": "giveaccesstoqueueonly",
            "PolicyDocument": {
              "Version": "2012-10-17",
              "Statement": [
                {
                  "Effect": "Allow",
                  "Action": [
                    "sqs:*"
                  ],
                  "Resource": [
                    "myqueue.Arn"
                  ]
                },
                {
                  "Effect": "Deny",
                  "Action": [
                    "sqs:*"
                  ],
                  "NotResource": [
                    "myqueue.Arn"
                  ]
                }
              ]
            }
          }
        ],
        "Path": "/"
      }
    }
  }
}

```


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
AWSTemplateFormatVersion: "2010-09-09"
Description: A sample template
Resources:
    myTopuser:
      Type: AWS::IAM::User
      Properties:
        Path: "/"
        LoginProfile:
         Password:
         - !Ref NoEcho
         PasswordResetRequired: false
        Policies:
        - PolicyName: giveaccesstoqueueonly
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
            - Effect: Allow
              Action:
              - sqs:*
              Resource:
              - !GetAtt myqueue.Arn
            - Effect: Deny
              Action:
              - sqs:*
              NotResource:
              - !GetAtt myqueue.Arn

```
```yaml title="Negative test num. 2 - yaml file"

AWSTemplateFormatVersion: "2010-09-09"
Description: A sample template
Resources:
    myNewuser:
      Type: AWS::IAM::User
      Properties:
        Path: "/"
        LoginProfile:
         Password:
         - !Ref secretsmanager
         PasswordResetRequired: false
        Policies:
        - PolicyName: giveaccesstoqueueonly
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
            - Effect: Allow
              Action:
              - sqs:*
              Resource:
              - !GetAtt myqueue.Arn
            - Effect: Deny
              Action:
              - sqs:*
              NotResource:
              - !GetAtt myqueue.Arn

```
```json title="Negative test num. 3 - json file"
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "A sample template",
  "Resources": {
    "myTopuser": {
      "Type": "AWS::IAM::User",
      "Properties": {
        "Path": "/",
        "LoginProfile": {
          "Password": [
            "NoEcho"
          ],
          "PasswordResetRequired": false
        },
        "Policies": [
          {
            "PolicyName": "giveaccesstoqueueonly",
            "PolicyDocument": {
              "Version": "2012-10-17",
              "Statement": [
                {
                  "Effect": "Allow",
                  "Action": [
                    "sqs:*"
                  ],
                  "Resource": [
                    "myqueue.Arn"
                  ]
                },
                {
                  "Effect": "Deny",
                  "Action": [
                    "sqs:*"
                  ],
                  "NotResource": [
                    "myqueue.Arn"
                  ]
                }
              ]
            }
          }
        ]
      }
    }
  }
}

```
<details><summary>Negative test num. 4 - json file</summary>

```json
{
  "Resources": {
    "myNewuser": {
      "Type": "AWS::IAM::User",
      "Properties": {
        "Path": "/",
        "LoginProfile": {
          "Password": [
            "secretsmanager"
          ],
          "PasswordResetRequired": false
        },
        "Policies": [
          {
            "PolicyName": "giveaccesstoqueueonly",
            "PolicyDocument": {
              "Version": "2012-10-17",
              "Statement": [
                {
                  "Effect": "Allow",
                  "Action": [
                    "sqs:*"
                  ],
                  "Resource": [
                    "myqueue.Arn"
                  ]
                },
                {
                  "Effect": "Deny",
                  "Action": [
                    "sqs:*"
                  ],
                  "NotResource": [
                    "myqueue.Arn"
                  ]
                }
              ]
            }
          }
        ]
      }
    }
  },
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "A sample template"
}

```
</details>
