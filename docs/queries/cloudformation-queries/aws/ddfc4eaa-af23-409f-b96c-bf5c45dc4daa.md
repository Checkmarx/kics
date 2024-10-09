---
title: HTTP Port Open To Internet
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

-   **Query id:** ddfc4eaa-af23-409f-b96c-bf5c45dc4daa
-   **Query name:** HTTP Port Open To Internet
-   **Platform:** CloudFormation
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Networking and Firewall
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/668.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/668.html')">668</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/cloudFormation/aws/http_port_open)

### Description
The HTTP port is open to the internet in a Security Group<br>
[Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="10 11"
Resources:
  InstanceSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
        GroupDescription: Allow http to client host
        VpcId:
          Ref: myVPC
        SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0

```
```json title="Positive test num. 2 - json file" hl_lines="13 14"
{
  "Resources": {
    "InstanceSecurityGroup": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow http to client host",
        "VpcId": {
          "Ref": "myVPC"
        },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIp": "0.0.0.0/0"
          }
        ]
      }
    }
  }
}

```


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
Resources:
  InstanceSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
        GroupDescription: Allow http to client host
        VpcId:
          Ref: myVPC
        SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 192.168.0.0/16

```
```json title="Negative test num. 2 - json file"
{
  "Resources": {
    "InstanceSecurityGroup": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow http to client host",
        "VpcId": {
          "Ref": "myVPC"
        },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIp": "192.168.0.0/16"
          }
        ]
      }
    }
  }
}

```
