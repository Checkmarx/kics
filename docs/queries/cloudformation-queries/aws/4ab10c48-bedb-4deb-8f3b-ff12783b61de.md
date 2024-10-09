---
title: API Gateway X-Ray Disabled
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

-   **Query id:** 4ab10c48-bedb-4deb-8f3b-ff12783b61de
-   **Query name:** API Gateway X-Ray Disabled
-   **Platform:** CloudFormation
-   **Severity:** <span style="color:#edd57e">Low</span>
-   **Category:** Observability
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/778.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/778.html')">778</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/cloudFormation/aws/api_gateway_xray_disabled)

### Description
API Gateway should have X-Ray Tracing enabled<br>
[Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-stage.html#cfn-apigateway-stage-tracingenabled)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="13"
AWSTemplateFormatVersion: "2010-09-09"
Description: "BatchJobDefinition"
Resources:
  ProdPos3:
    Type: AWS::ApiGateway::Stage
    Properties:
      StageName: Prod
      Description: Prod Stage
      RestApiId: !Ref MyRestApi
      DeploymentId: !Ref TestDeployment
      DocumentationVersion: !Ref MyDocumentationVersion
      ClientCertificateId: !Ref ClientCertificate
      TracingEnabled: false
      Variables:
        Stack: Prod
      MethodSettings:
        - ResourcePath: /
          HttpMethod: GET
          MetricsEnabled: 'true'
          DataTraceEnabled: 'false'
        - ResourcePath: /stack
          HttpMethod: POST
          MetricsEnabled: 'true'
          DataTraceEnabled: 'false'
          ThrottlingBurstLimit: '999'
        - ResourcePath: /stack
          HttpMethod: GET
          MetricsEnabled: 'true'
          DataTraceEnabled: 'false'
          ThrottlingBurstLimit: '555'

```
```yaml title="Positive test num. 2 - yaml file" hl_lines="6"
AWSTemplateFormatVersion: "2010-09-09"
Description: "BatchJobDefinition"
Resources:
  ProdPos4:
    Type: AWS::ApiGateway::Stage
    Properties:
      StageName: Prod
      Description: Prod Stage
      RestApiId: !Ref MyRestApi
      DeploymentId: !Ref TestDeployment
      DocumentationVersion: !Ref MyDocumentationVersion
      ClientCertificateId: !Ref ClientCertificate
      Variables:
        Stack: Prod
      MethodSettings:
        - ResourcePath: /
          HttpMethod: GET
          MetricsEnabled: 'true'
          DataTraceEnabled: 'false'
        - ResourcePath: /stack
          HttpMethod: POST
          MetricsEnabled: 'true'
          DataTraceEnabled: 'false'
          ThrottlingBurstLimit: '999'
        - ResourcePath: /stack
          HttpMethod: GET
          MetricsEnabled: 'true'
          DataTraceEnabled: 'false'
          ThrottlingBurstLimit: '555'

```
```json title="Positive test num. 3 - json file" hl_lines="23"
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "ProdPos1": {
      "Type": "AWS::ApiGateway::Stage",
      "Properties": {
        "StageName": "Prod",
        "RestApiId": {
          "Ref": "MyRestApi"
        },
        "DeploymentId": {
          "Ref": "TestDeployment"
        },
        "DocumentationVersion": {
          "Ref": "MyDocumentationVersion"
        },
        "ClientCertificateId": {
          "Ref": "ClientCertificate"
        },
        "Variables": {
          "Stack": "Prod"
        },
        "TracingEnabled": "false",
        "MethodSettings": [
          {
            "ResourcePath": "/",
            "HttpMethod": "GET",
            "MetricsEnabled": "true",
            "DataTraceEnabled": "false"
          },
          {
            "ResourcePath": "/stack",
            "HttpMethod": "POST",
            "MetricsEnabled": "true",
            "DataTraceEnabled": "false",
            "ThrottlingBurstLimit": "999"
          },
          {
            "ResourcePath": "/stack",
            "HttpMethod": "GET",
            "MetricsEnabled": "true",
            "DataTraceEnabled": "false",
            "ThrottlingBurstLimit": "555"
          }
        ]
      }
    }
  }
}

```
<details><summary>Positive test num. 4 - json file</summary>

```json hl_lines="6"
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "ProdPos2": {
      "Type": "AWS::ApiGateway::Stage",
      "Properties": {
        "StageName": "Prod",
        "RestApiId": {
          "Ref": "MyRestApi"
        },
        "DeploymentId": {
          "Ref": "TestDeployment"
        },
        "DocumentationVersion": {
          "Ref": "MyDocumentationVersion"
        },
        "ClientCertificateId": {
          "Ref": "ClientCertificate"
        },
        "Variables": {
          "Stack": "Prod"
        },
        "MethodSettings": [
          {
            "ResourcePath": "/",
            "HttpMethod": "GET",
            "MetricsEnabled": "true",
            "DataTraceEnabled": "false"
          },
          {
            "ResourcePath": "/stack",
            "HttpMethod": "POST",
            "MetricsEnabled": "true",
            "DataTraceEnabled": "false",
            "ThrottlingBurstLimit": "999"
          },
          {
            "ResourcePath": "/stack",
            "HttpMethod": "GET",
            "MetricsEnabled": "true",
            "DataTraceEnabled": "false",
            "ThrottlingBurstLimit": "555"
          }
        ]
      }
    }
  }
}

```
</details>


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
AWSTemplateFormatVersion: "2010-09-09"
Description: "BatchJobDefinition"
Resources:
  ProdNeg1:
    Type: AWS::ApiGateway::Stage
    Properties:
      StageName: Prod
      Description: Prod Stage
      RestApiId: !Ref MyRestApi
      DeploymentId: !Ref TestDeployment
      DocumentationVersion: !Ref MyDocumentationVersion
      ClientCertificateId: !Ref ClientCertificate
      TracingEnabled: true
      Variables:
        Stack: Prod
      MethodSettings:
        - ResourcePath: /
          HttpMethod: GET
          MetricsEnabled: 'true'
          DataTraceEnabled: 'false'
        - ResourcePath: /stack
          HttpMethod: POST
          MetricsEnabled: 'true'
          DataTraceEnabled: 'false'
          ThrottlingBurstLimit: '999'
        - ResourcePath: /stack
          HttpMethod: GET
          MetricsEnabled: 'true'
          DataTraceEnabled: 'false'
          ThrottlingBurstLimit: '555'

```
```json title="Negative test num. 2 - json file"
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "ProdNeg2": {
      "Type": "AWS::ApiGateway::Stage",
      "Properties": {
        "StageName": "Prod",
        "RestApiId": {
          "Ref": "MyRestApi"
        },
        "DeploymentId": {
          "Ref": "TestDeployment"
        },
        "DocumentationVersion": {
          "Ref": "MyDocumentationVersion"
        },
        "ClientCertificateId": {
          "Ref": "ClientCertificate"
        },
        "Variables": {
          "Stack": "Prod"
        },
        "TracingEnabled": "true",
        "MethodSettings": [
          {
            "ResourcePath": "/",
            "HttpMethod": "GET",
            "MetricsEnabled": "true",
            "DataTraceEnabled": "false"
          },
          {
            "ResourcePath": "/stack",
            "HttpMethod": "POST",
            "MetricsEnabled": "true",
            "DataTraceEnabled": "false",
            "ThrottlingBurstLimit": "999"
          },
          {
            "ResourcePath": "/stack",
            "HttpMethod": "GET",
            "MetricsEnabled": "true",
            "DataTraceEnabled": "false",
            "ThrottlingBurstLimit": "555"
          }
        ]
      }
    }
  }
}

```
