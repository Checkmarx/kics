AWSTemplateFormatVersion: "2010-09-11"
Description: Sample CloudFormation template for DynamoDB with AWS-Owned CMK
Resources:
  DynamoDBOnDemandTable4:
    Type: "AWS::DynamoDB::Table"
    Properties:
      TableName: "dynamodb-kms-2"
      AttributeDefinitions:
        - AttributeName: pk
          AttributeType: S
      KeySchema:
        - AttributeName: pk
          KeyType: HASH
      BillingMode: PAY_PER_REQUEST
      SSESpecification:
        SSEType: "KMS"
