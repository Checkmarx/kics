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
-   **Risk score:** <span style="color:#ff7213">4.9</span>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/cloudFormation/aws/http_port_open)

### Description
The HTTP port is open to the internet in a Security Group<br>
[Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="38 10 79 51 22 63"
Resources:
# IPv4 Rules
  Positive1IPv4_1:
    Type: AWS::EC2::SecurityGroup
    Properties:
        GroupDescription: Allow http to client host
        VpcId:
          Ref: myVPC
        SecurityGroupIngress:
        - IpProtocol: "tcp"
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0

  Positive1IPv4_2:
    Type: AWS::EC2::SecurityGroup
    Properties:
        GroupDescription: Allow http to client host
        VpcId:
          Ref: myVPC
        SecurityGroupIngress:
        - IpProtocol: "-1"
          FromPort: 10
          ToPort: 10
          CidrIp: 0.0.0.0/0

  Positive1ArrayTestIPv4:
    Type: AWS::EC2::SecurityGroup
    Properties:
        GroupDescription: Allow http to client host
        VpcId:
          Ref: myVPC
        SecurityGroupIngress:
        - IpProtocol: "tcp"
          FromPort: 0
          ToPort: 1000
          CidrIp: 192.0.0.0/16
        - IpProtocol: "6"
          FromPort: 0
          ToPort: 100
          CidrIp: 0.0.0.0/0
          
# IPv6 Rules
  Positive1IPv6_1:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow http to client host
      VpcId:
        Ref: myVPC
      SecurityGroupIngress:
      - IpProtocol: "tcp"
        FromPort: 80
        ToPort: 80
        CidrIpv6: "::/0"

  Positive1IPv6_2:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow http to client host
      VpcId:
        Ref: myVPC
      SecurityGroupIngress:
      - IpProtocol: "-1"
        FromPort: 10
        ToPort: 10
        CidrIpv6: "::/0"

  Positive1ArrayTestIPv6:
    Type: AWS::EC2::SecurityGroup
    Properties:
        GroupDescription: Allow http to client host
        VpcId:
          Ref: myVPC
        SecurityGroupIngress:
        - IpProtocol: "tcp"           
          FromPort: 0
          ToPort: 1000
          CidrIpv6: "2400:cb00::/32"  #should not flag - used to test array index search  
        - IpProtocol: "6"
          FromPort: 70
          ToPort: 90
          CidrIpv6: "0000:0000:0000:0000:0000:0000:0000:0000/0"
```
```yaml title="Positive test num. 2 - yaml file" hl_lines="40 12 49 21 31"
Resources:

  DualStackSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: "Security group for IPv4 and IPv6 ingress rules"
      VpcId: !Ref MyVPC

# IPv4 Rules
  IPv4Ingress1:
    Type: AWS::EC2::SecurityGroupIngress
    Properties:
      GroupId: !Ref DualStackSecurityGroup
      IpProtocol: "-1"
      FromPort: 10
      ToPort: 10
      CidrIp: "0.0.0.0/0"

  IPv4Ingress2:
    Type: AWS::EC2::SecurityGroupIngress
    Properties:
      GroupId: !Ref DualStackSecurityGroup
      IpProtocol: "tcp"
      FromPort: 70
      ToPort: 90
      CidrIp: "0.0.0.0/0"

# IPv6 Rules
  IPv6Ingress1:
    Type: AWS::EC2::SecurityGroupIngress
    Properties:
      GroupId: !Ref DualStackSecurityGroup
      IpProtocol: "tcp"
      FromPort: 80
      ToPort: 80
      CidrIpv6: "::/0"

  IPv6Ingress2:
    Type: AWS::EC2::SecurityGroupIngress
    Properties:
      GroupId: !Ref DualStackSecurityGroup
      IpProtocol: "tcp"
      FromPort: 70
      ToPort: 90
      CidrIpv6: "0000:0000:0000:0000:0000:0000:0000:0000/0"

  IPv6Ingress3:
    Type: AWS::EC2::SecurityGroupIngress
    Properties:
      GroupId: !Ref DualStackSecurityGroup
      IpProtocol: "-1"
      FromPort: 10
      ToPort: 10
      CidrIpv6: "0000:0000:0000:0000:0000:0000:0000:0000/0"
```
```json title="Positive test num. 3 - json file" hl_lines="97 10 76 46 25 61"
{
  "Resources": {
    "Positive1IPv4_1": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow http to client host",
        "VpcId": { "Ref": "myVPC" },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIp": "0.0.0.0/0"
          }
        ]
      }
    },
    "Positive1IPv4_2": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow http to client host",
        "VpcId": { "Ref": "myVPC" },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "-1",
            "FromPort": 10,
            "ToPort": 10,
            "CidrIp": "0.0.0.0/0"
          }
        ]
      }
    },
    "Positive1ArrayTestIPv4": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow http to client host",
        "VpcId": { "Ref": "myVPC" },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "tcp",
            "FromPort": 0,
            "ToPort": 1000,
            "CidrIp": "192.0.0.0/16"
          },
          {
            "IpProtocol": "6",
            "FromPort": 0,
            "ToPort": 100,
            "CidrIp": "0.0.0.0/0"
          }
        ]
      }
    },
    "Positive1IPv6_1": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow http to client host",
        "VpcId": { "Ref": "myVPC" },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIpv6": "::/0"
          }
        ]
      }
    },
    "Positive1IPv6_2": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow http to client host",
        "VpcId": { "Ref": "myVPC" },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "-1",
            "FromPort": 10,
            "ToPort": 10,
            "CidrIpv6": "::/0"
          }
        ]
      }
    },
    "Positive1ArrayTestIPv6": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow http to client host",
        "VpcId": { "Ref": "myVPC" },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "tcp",
            "FromPort": 0,
            "ToPort": 1000,
            "CidrIpv6": "2400:cb00::/32"
          },
          {
            "IpProtocol": "6",
            "FromPort": 70,
            "ToPort": 90,
            "CidrIpv6": "0000:0000:0000:0000:0000:0000:0000:0000/0"
          }
        ]
      }
    }
  }
}

```
<details><summary>Positive test num. 4 - json file</summary>

```json hl_lines="38 14 50 26 62"
{
    "Resources": {
        "DualStackSecurityGroup": {
            "Type": "AWS::EC2::SecurityGroup",
            "Properties": {
                "GroupDescription": "Security group for IPv4 and IPv6 ingress rules",
                "VpcId": {
                    "Ref": "MyVPC"
                }
            }
        },
        "IPv4Ingress1": {
            "Type": "AWS::EC2::SecurityGroupIngress",
            "Properties": {
                "GroupId": {
                    "Ref": "DualStackSecurityGroup"
                },
                "IpProtocol": "-1",
                "FromPort": 10,
                "ToPort": 10,
                "CidrIp": "0.0.0.0/0"
            }
        },
        "IPv4Ingress2": {
            "Type": "AWS::EC2::SecurityGroupIngress",
            "Properties": {
                "GroupId": {
                    "Ref": "DualStackSecurityGroup"
                },
                "IpProtocol": "tcp",
                "FromPort": 70,
                "ToPort": 90,
                "CidrIp": "0.0.0.0/0"
            }
        },
        "IPv6Ingress1": {
            "Type": "AWS::EC2::SecurityGroupIngress",
            "Properties": {
                "GroupId": {
                    "Ref": "DualStackSecurityGroup"
                },
                "IpProtocol": "tcp",
                "FromPort": 80,
                "ToPort": 80,
                "CidrIpv6": "::/0"
            }
        },
        "IPv6Ingress2": {
            "Type": "AWS::EC2::SecurityGroupIngress",
            "Properties": {
                "GroupId": {
                    "Ref": "DualStackSecurityGroup"
                },
                "IpProtocol": "tcp",
                "FromPort": 70,
                "ToPort": 90,
                "CidrIpv6": "0000:0000:0000:0000:0000:0000:0000:0000/0"
            }
        },
        "IPv6Ingress3": {
            "Type": "AWS::EC2::SecurityGroupIngress",
            "Properties": {
                "GroupId": {
                    "Ref": "DualStackSecurityGroup"
                },
                "IpProtocol": "-1",
                "FromPort": 10,
                "ToPort": 10,
                "CidrIpv6": "0000:0000:0000:0000:0000:0000:0000:0000/0"
            }
        }
    }
}
```
</details>


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
Resources:
# IPv4 Rules
  Negative1IPv4_1:
    Type: AWS::EC2::SecurityGroup
    Properties:
        GroupDescription: Allow http to client host
        VpcId:
          Ref: myVPC
        SecurityGroupIngress:
        - IpProtocol: "udp"  # wrong protocol
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0

  Negative1IPv4_2:
    Type: AWS::EC2::SecurityGroup
    Properties:
        GroupDescription: Allow http to client host
        VpcId:
          Ref: myVPC
        SecurityGroupIngress:
        - IpProtocol: "tcp"
          FromPort: 100
          ToPort: 200      # not catching port 80
          CidrIp: 0.0.0.0/0

  Negative1ArrayTestIPv4:
    Type: AWS::EC2::SecurityGroup
    Properties:
        GroupDescription: Allow http to client host
        VpcId:
          Ref: myVPC
        SecurityGroupIngress: 
        - IpProtocol: "-1"    
          FromPort: 0
          ToPort: 1000
          CidrIp: 192.0.0.0/16  # CidrIP is not 0:0:0:0/0
        - IpProtocol: "udp"   # all fields "incorrect"
          FromPort: 1000
          ToPort: 2000
          CidrIp: 192.120.0.0/16

# IPv6 Rules
  Negative1IPv6_1:
    Type: AWS::EC2::SecurityGroup
    Properties:
        GroupDescription: Allow http to client host
        VpcId:
          Ref: myVPC
        SecurityGroupIngress:
        - IpProtocol: "udp"  # wrong protocol
          FromPort: 80
          ToPort: 80
          CidrIpv6: "::/0"

  Negative1IPv6_2:
    Type: AWS::EC2::SecurityGroup
    Properties:
        GroupDescription: Allow http to client host
        VpcId:
          Ref: myVPC
        SecurityGroupIngress:
        - IpProtocol: "tcp"
          FromPort: 5000
          ToPort: 5000      # not catching port 80
          CidrIpv6: "0000:0000:0000:0000:0000:0000:0000:0000/0"

  Negative1ArrayTestIPv6:
    Type: AWS::EC2::SecurityGroup
    Properties:
        GroupDescription: Allow http to client host
        VpcId:
          Ref: myVPC
        SecurityGroupIngress: 
        - IpProtocol: "-1"    
          FromPort: 0
          ToPort: 1000
          CidrIpv6: "2400:cb00::/32"  # CidrIpv6 is not ::/0
        - IpProtocol: "udp"   # all fields "incorrect"
          FromPort: 1000
          ToPort: 2000
          CidrIpv6: "2400:cb00::/32"
```
```yaml title="Negative test num. 2 - yaml file"
Resources:

  Negative2SecurityGroup:
      Type: AWS::EC2::SecurityGroup
      Properties:
        GroupDescription: "Security group for negative test cases"
        VpcId: !Ref MyVPC  

# IPv4 Rules
  Negative2IPv4Ingress1:
    Type: AWS::EC2::SecurityGroupIngress
    Properties:
      GroupId: !Ref Negative2SecurityGroup
      IpProtocol: "udp"      # incorrect protocol
      FromPort: 80
      ToPort: 80
      CidrIp: "0.0.0.0/0"

  Negative2IPv4Ingress2:
    Type: AWS::EC2::SecurityGroupIngress
    Properties:
      GroupId: !Ref Negative2SecurityGroup
      IpProtocol: "tcp"
      FromPort: 100      # not catching port 80
      ToPort: 200
      CidrIp: "0.0.0.0/0"

  Negative2IPv4Ingress3:
    Type: AWS::EC2::SecurityGroupIngress
    Properties:
      GroupId: !Ref Negative2SecurityGroup
      IpProtocol: "-1"
      FromPort: 0
      ToPort: 100
      CidrIp: "8.8.0.0/16"  # CidrIP is not 0:0:0:0/0

  Negative2IPv4Ingress4:
    Type: AWS::EC2::SecurityGroupIngress
    Properties:
      GroupId: !Ref Negative2SecurityGroup 
      IpProtocol: "udp"    # all fields "incorrect"
      FromPort: 5000
      ToPort: 5000
      CidrIp: "8.8.0.0/16"

# IPv6 Rules
  Negative2IPv6Ingress1:
    Type: AWS::EC2::SecurityGroupIngress
    Properties:
      GroupId: !Ref Negative2SecurityGroup
      IpProtocol: "udp"  # incorrect protocol
      FromPort: 80
      ToPort: 80
      CidrIpv6: "::/0"

  Negative2IPv6Ingress2:
    Type: AWS::EC2::SecurityGroupIngress
    Properties:
      GroupId: !Ref Negative2SecurityGroup
      IpProtocol: "tcp"
      FromPort: 5000    # not catching port 80
      ToPort: 5000
      CidrIpv6: "0000:0000:0000:0000:0000:0000:0000:0000/0"

  Negative2IPv6Ingress3:
    Type: AWS::EC2::SecurityGroupIngress
    Properties:
      GroupId: !Ref Negative2SecurityGroup
      IpProtocol: "-1"
      FromPort: 0
      ToPort: 100
      CidrIpv6: "2400:cb00::/32"  # CidrIP is not 0:0:0:0/0

  Negative2IPv6Ingress4:
    Type: AWS::EC2::SecurityGroupIngress
    Properties:
      GroupId: !Ref Negative2SecurityGroup   # all fields "incorrect"
      IpProtocol: "udp" 
      FromPort: 5000
      ToPort: 5000
      CidrIpv6: "2400:cb00::/32"
```
```json title="Negative test num. 3 - json file"
{
  "Resources": {
    "Negative1IPv4_1": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow http to client host",
        "VpcId": { "Ref": "myVPC" },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "udp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIp": "0.0.0.0/0"
          }
        ]
      }
    },
    "Negative1IPv4_2": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow http to client host",
        "VpcId": { "Ref": "myVPC" },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "tcp",
            "FromPort": 100,
            "ToPort": 200,
            "CidrIp": "0.0.0.0/0"
          }
        ]
      }
    },
    "Negative1ArrayTestIPv4": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow http to client host",
        "VpcId": { "Ref": "myVPC" },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "-1",
            "FromPort": 0,
            "ToPort": 1000,
            "CidrIp": "192.0.0.0/16"
          },
          {
            "IpProtocol": "udp",
            "FromPort": 1000,
            "ToPort": 2000,
            "CidrIp": "192.120.0.0/16"
          }
        ]
      }
    },
    "Negative1IPv6_1": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow http to client host",
        "VpcId": { "Ref": "myVPC" },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "udp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIpv6": "::/0"
          }
        ]
      }
    },
    "Negative1IPv6_2": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow http to client host",
        "VpcId": { "Ref": "myVPC" },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "tcp",
            "FromPort": 5000,
            "ToPort": 5000,
            "CidrIpv6": "0000:0000:0000:0000:0000:0000:0000:0000/0"
          }
        ]
      }
    },
    "Negative1ArrayTestIPv6": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow http to client host",
        "VpcId": { "Ref": "myVPC" },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "-1",
            "FromPort": 0,
            "ToPort": 1000,
            "CidrIpv6": "2400:cb00::/32"
          },
          {
            "IpProtocol": "udp",
            "FromPort": 1000,
            "ToPort": 2000,
            "CidrIpv6": "2400:cb00::/32"
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
    "Negative2SecurityGroup": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Security group for negative test cases",
        "VpcId": {
          "Ref": "MyVPC"
        }
      }
    },
    "Negative2IPv4Ingress1": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "GroupId": {
          "Ref": "Negative2SecurityGroup"
        },
        "IpProtocol": "udp",
        "FromPort": 80,
        "ToPort": 80,
        "CidrIp": "0.0.0.0/0"
      }
    },
    "Negative2IPv4Ingress2": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "GroupId": {
          "Ref": "Negative2SecurityGroup"
        },
        "IpProtocol": "tcp",
        "FromPort": 100,
        "ToPort": 200,
        "CidrIp": "0.0.0.0/0"
      }
    },
    "Negative2IPv4Ingress3": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "GroupId": {
          "Ref": "Negative2SecurityGroup"
        },
        "IpProtocol": "-1",
        "FromPort": 0,
        "ToPort": 100,
        "CidrIp": "8.8.0.0/16"
      }
    },
    "Negative2IPv4Ingress4": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "GroupId": {
          "Ref": "Negative2SecurityGroup"
        },
        "IpProtocol": "udp",
        "FromPort": 5000,
        "ToPort": 5000,
        "CidrIp": "8.8.0.0/16"
      }
    },
    "Negative2IPv6Ingress1": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "GroupId": {
          "Ref": "Negative2SecurityGroup"
        },
        "IpProtocol": "udp",
        "FromPort": 22,
        "ToPort": 22,
        "CidrIpv6": "::/0"
      }
    },
    "Negative2IPv6Ingress2": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "GroupId": {
          "Ref": "Negative2SecurityGroup"
        },
        "IpProtocol": "tcp",
        "FromPort": 5000,
        "ToPort": 5000,
        "CidrIpv6": "0000:0000:0000:0000:0000:0000:0000:0000/0"
      }
    },
    "Negative2IPv6Ingress3": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "GroupId": {
          "Ref": "Negative2SecurityGroup"
        },
        "IpProtocol": "-1",
        "FromPort": 22,
        "ToPort": 22,
        "CidrIpv6": "2400:cb00::/32"
      }
    },
    "Negative2IPv6Ingress4": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "GroupId": {
          "Ref": "Negative2SecurityGroup"
        },
        "IpProtocol": "udp",
        "FromPort": 5000,
        "ToPort": 5000,
        "CidrIpv6": "2400:cb00::/32"
      }
    }
  }
}

```
</details>

