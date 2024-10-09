---
title: Lambda Function Without Dead Letter Queue
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

-   **Query id:** c2eae442-d3ba-4cb1-84ca-1db4f80eae3d
-   **Query name:** Lambda Function Without Dead Letter Queue
-   **Platform:** CloudFormation
-   **Severity:** <span style="color:#edd57e">Low</span>
-   **Category:** Insecure Configurations
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/390.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/390.html')">390</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/cloudFormation/aws/lambda_function_without_dead_letter_queue)

### Description
AWS Lambda Function should be configured for a Dead Letter Queue(DLQ)<br>
[Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-function.html#cfn-lambda-function-deadletterconfig)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="6"
AWSTemplateFormatVersion: '2010-09-09'
Description: VPC function.
Resources:
  Function:
    Type: AWS::Lambda::Function
    Properties:
      Handler: index.handler
      Role: arn:aws:iam::123456789012:role/lambda-role
      Code:
        S3Bucket: my-bucket
        S3Key: function.zip
      Runtime: nodejs12.x
      Timeout: 5
      TracingConfig:
        Mode: Active
      VpcConfig:
        SecurityGroupIds:
          - sg-085912345678492fb
        SubnetIds:
          - subnet-071f712345678e7c8
          - subnet-07fd123456788a036
      Tags:
        - Key: Description
          Value: VPC Function
        - Key: Type
          Value: AWS Lambda Function

```
```yaml title="Positive test num. 2 - yaml file" hl_lines="27 6"
AWSTemplateFormatVersion: '2010-09-09'
Description: VPC function.
Resources:
  Function2:
    Type: AWS::Lambda::Function
    Properties:
      Handler: index.handler
      Role: arn:aws:iam::123456789012:role/lambda-role
      Code:
        S3Bucket: my-bucket
        S3Key: function.zip
      Runtime: nodejs12.x
      Timeout: 5
      TracingConfig:
        Mode: Active
      VpcConfig:
        SecurityGroupIds:
          - sg-085912345678492fb
        SubnetIds:
          - subnet-071f712345678e7c8
          - subnet-07fd123456788a036
      Tags:
        - Key: Description
          Value: VPC Function
        - Key: Type
          Value: AWS Lambda Function
      DeadLetterConfig:

```


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
AWSTemplateFormatVersion: '2010-09-09'
Description: VPC function.
Resources:
  Function3:
    Type: AWS::Lambda::Function
    Properties:
      Handler: index.handler
      Role: arn:aws:iam::123456789012:role/lambda-role
      Code:
        S3Bucket: my-bucket
        S3Key: function.zip
      Runtime: nodejs12.x
      Timeout: 5
      TracingConfig:
        Mode: Active
      VpcConfig:
        SecurityGroupIds:
          - sg-085912345678492fb
        SubnetIds:
          - subnet-071f712345678e7c8
          - subnet-07fd123456788a036
      Tags:
        - Key: Description
          Value: VPC Function
        - Key: Type
          Value: AWS Lambda Function
      DeadLetterConfig:
        TargetArn: arn:aws:sqs:us-east-1:2324243535:aaa

```
