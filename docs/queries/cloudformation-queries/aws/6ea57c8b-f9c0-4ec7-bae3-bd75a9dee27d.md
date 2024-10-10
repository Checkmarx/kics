---
title: SDB Domain Declared As A Resource
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

-   **Query id:** 6ea57c8b-f9c0-4ec7-bae3-bd75a9dee27d
-   **Query name:** SDB Domain Declared As A Resource
-   **Platform:** CloudFormation
-   **Severity:** <span style="color:#edd57e">Low</span>
-   **Category:** Resource Management
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/665.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/665.html')">665</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/cloudFormation/aws/sdb_domain_declared_as_a_resource)

### Description
SimpleDB Domain resource should not be declared<br>
[Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-simpledb.html)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="8"
AWSTemplateFormatVersion: "2010-09-09"
Description: "SDB Domain declared"
Resources:
  HostedZone:
    Type: AWS::Route53::HostedZone
    Properties:
      Name: "HostedZone"
  SBDDomain:
    Type: AWS::SDB::Domain
    Properties:
      Description: "Some information"

```
```json title="Positive test num. 2 - json file" hl_lines="11"
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "SDB Domain declared",
  "Resources": {
    "HostedZone": {
      "Type": "AWS::Route53::HostedZone",
      "Properties": {
        "Name": "HostedZone"
      }
    },
    "SBDDomain": {
      "Type": "AWS::SDB::Domain",
      "Properties": {
        "Description": "Some information"
      }
    }
  }
}

```


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
AWSTemplateFormatVersion: "2010-09-09"
Description: "SDB Domain declared"
Resources:
  HostedZone:
    Type: AWS::Route53::HostedZone
    Properties:
      Name: "HostedZone"

```
```json title="Negative test num. 2 - json file"
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "SDB Domain declared",
  "Resources": {
    "HostedZone": {
      "Type": "AWS::Route53::HostedZone",
      "Properties": {
        "Name": "HostedZone"
      }
    }
  }
}

```
