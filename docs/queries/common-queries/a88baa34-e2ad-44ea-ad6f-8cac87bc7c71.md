---
title: Passwords And Secrets
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

-   **Query id:** a88baa34-e2ad-44ea-ad6f-8cac87bc7c71
-   **Query name:** Passwords And Secrets
-   **Platform:** Common
-   **Severity:** <span style="color:#bb2124">High</span>
-   **Category:** Secret Management
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/798.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/798.html')">798</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/common/passwords_and_secrets)

### Description
Query to find passwords and secrets in infrastructure code.<br>
[Documentation](https://docs.kics.io/latest/secrets/)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="8"
#k8s test
apiVersion: v1
kind: Secret
metadata:
  name: secret-basic-auth
type: kubernetes.io/basic-auth
stringData:
  password: "root"

```
```json title="Positive test num. 2 - json file" hl_lines="17 27 7"
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "myStackWithParams": {
      "Type": "AWS::CloudFormation::Stack",
      "Properties": {
        "TemplateURL": "http://bob:sekret@example.invalid/some/path",
        "Parameters": {
          "InstanceType": "t1.micro",
          "KeyName": "mykey"
        }
      }
    },
    "myStackWithParams_1": {
      "Type": "AWS::CloudFormation::Stack",
      "Properties": {
        "TemplateURL": "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX",
        "Parameters": {
          "InstanceType": "t1.micro",
          "KeyName": "mykey"
        }
      }
    },
    "myStackWithParams_2": {
      "Type": "AWS::CloudFormation::Stack",
      "Properties": {
        "TemplateURL": "https://team_name.webhook.office.com/webhookb2/7aa49aa6-7840-443d-806c-08ebe8f59966@c662313f-14fc-43a2-9a7a-d2e27f4f3478/IncomingWebhook/8592f62b50cf41b9b93ba0c0a00a0b88/eff4cd58-1bb8-4899-94de-795f656b4a18",
        "Parameters": {
          "InstanceType": "t1.micro",
          "KeyName": "mykey"
        }
      }
    }
  }
}

```
```yaml title="Positive test num. 3 - yaml file" hl_lines="9 11 7"
openapi: 3.0.0
info:
  title: Simple API Overview
  version: 1.0.0
paths: {}
servers:
  - url: http://bob:sekret@example.invalid/some/path
    description: My API Server 1
  - url: https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX
    description: My API Server 2
  - url: https://team_name.webhook.office.com/webhookb2/7aa49aa6-7840-443d-806c-08ebe8f59966@c662313f-14fc-43a2-9a7a-d2e27f4f3478/IncomingWebhook/8592f62b50cf41b9b93ba0c0a00a0b88/eff4cd58-1bb8-4899-94de-795f656b4a18
    description: My API Server 3

```
<details><summary>Positive test num. 4 - json file</summary>

```json hl_lines="8 19 11 15"
{
  "openapi": "3.0.0",
  "info": {
    "title": "Simple API Overview",
    "version": "1.0.0"
  },
  "paths": {},
  "password": "Masu121m2d12d1",
  "servers": [
    {
      "url": "http://bob:sekret@example.invalid/some/path",
      "description": "My API Server 1"
    },
    {
      "url": "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX",
      "description": "My API Server 2"
    },
    {
      "url": "https://team_name.webhook.office.com/webhookb2/7aa49aa6-7840-443d-806c-08ebe8f59966@c662313f-14fc-43a2-9a7a-d2e27f4f3478/IncomingWebhook/8592f62b50cf41b9b93ba0c0a00a0b88/eff4cd58-1bb8-4899-94de-795f656b4a18",
      "description": "My API Server 3"
    }
  ]
}

```
</details>
<details><summary>Positive test num. 5 - tf file</summary>

```tf hl_lines="6"
resource "aws_transfer_ssh_key" "example" {
	server_id = aws_transfer_server.example.id
	user_name = aws_transfer_user.example.user_name
	body      = <<EOT
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAaAAAABNlY2RzYS
1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTTD+Q+10oNWDzXxx9x2bOobcXAA4rd
jGaQoqJjcXRWR2TS1ioKvML1fI5KLP4kuF3TlyPTLgJxlfrJtYYEfGHwAAAA0FjbkWRY25
FkAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNMP5D7XSg1YPNfH
H3HZs6htxcADit2MZpCiomNxdFZHZNLWKgq8wvV8jkos/iS4XdOXI9MuAnGV+sm1hgR8Yf
AAAAAgHI23o+KRbewZJJxFExEGwiOPwM7gonjATdzLP+YT/6sAAAA0cm9nZXJpb3AtbWFj
Ym9va0BSb2dlcmlvUC1NYWNCb29rcy1NYWNCb29rLVByby5sb2NhbAECAwQ=
-----END OPENSSH PRIVATE KEY-----
EOT
}

```
</details>
<details><summary>Positive test num. 6 - tf file</summary>

```tf hl_lines="17 18"

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "positive1" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  tags = {
    Name = "test"
  }

  user_data = <<EOF
#!/bin/bash
apt-get install -y awscli
export AWS_ACCESS_KEY_ID=AKIASXANV9XVIJ1YCIJ5
export AWS_SECRET_ACCESS_KEY=ZH6HDV/EolIbS2UTxbLplGpukOdaGmlq9MtAg1Xv
EOF

  credit_specification {
    cpu_credits = "unlimited"
  }
}

```
</details>
<details><summary>Positive test num. 7 - tf file</summary>

```tf hl_lines="14 15"
resource "aws_instance" "web_host" {
  # ec2 have plain text secrets in user data
  ami           = var.ami
  instance_type = "t2.nano"

  vpc_security_group_ids = ["aws_security_group.web-node.id"]
  subnet_id = aws_subnet.web_subnet.id
  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMAAA
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=us-west-2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF
  tags = merge({
    Name = "${local.resource_prefix.value}-ec2"
    }, {
    git_last_modified_by = "email@email.com"
    git_modifiers        = "foo.bar"
    git_org              = "checkmarx"
    git_repo             = "kics"
  })
}

resource "aws_ebs_volume" "web_host_storage" {
  # unencrypted volume
  availability_zone = "${var.region}a"
  #encrypted         = false  # Setting this causes the volume to be recreated on apply
  size = 1
  tags = merge({
    Name = "${local.resource_prefix.value}-ebs"
    }, {
    git_last_modified_by = "email@email.com"
    git_modifiers        = "foo.bar"
    git_org              = "checkmarx"
    git_repo             = "kics"
  })
}

resource "aws_ebs_snapshot" "example_snapshot" {
  # ebs snapshot without encryption
  volume_id   = aws_ebs_volume.web_host_storage.id
  description = "${local.resource_prefix.value}-ebs-snapshot"
  tags = merge({
    Name = "${local.resource_prefix.value}-ebs-snapshot"
    }, {
    git_last_modified_by = "email@email.com"
    git_modifiers        = "foo.bar"
    git_org              = "checkmarx"
    git_repo             = "kics"
  })
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.web_host_storage.id
  instance_id = aws_instance.web_host.id
}

resource "aws_security_group" "web-node" {
  # security group is open to the world in SSH port
  name        = "${local.resource_prefix.value}-sg"
  description = "${local.resource_prefix.value} Security Group"
  vpc_id      = aws_vpc.web_vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  depends_on = [aws_vpc.web_vpc]
  tags = {
    git_last_modified_by = "email@email.com"
    git_modifiers        = "foo.bar"
    git_org              = "checkmarx"
    git_repo             = "kics"
  }
}

resource "aws_vpc" "web_vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge({
    Name = "${local.resource_prefix.value}-vpc"
    }, {
    git_last_modified_by = "email@email.com"
    git_modifiers        = "foo.bar"
    git_org              = "checkmarx"
    git_repo             = "kics"
  })
}

resource "aws_subnet" "web_subnet" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = merge({
    Name = "${local.resource_prefix.value}-subnet"
    }, {
    git_last_modified_by = "email@email.com"
    git_modifiers        = "foo.bar"
    git_org              = "checkmarx"
    git_repo             = "kics"
  })
}

resource "aws_subnet" "web_subnet2" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "172.16.11.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = merge({
    Name = "${local.resource_prefix.value}-subnet2"
    }, {
    git_last_modified_by = "email@email.com"
    git_modifiers        = "foo.bar"
    git_org              = "checkmarx"
    git_repo             = "kics"
  })
}


resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.web_vpc.id

  tags = merge({
    Name = "${local.resource_prefix.value}-igw"
    }, {
    git_last_modified_by = "email@email.com"
    git_modifiers        = "foo.bar"
    git_org              = "checkmarx"
    git_repo             = "kics"
  })
}

resource "aws_route_table" "web_rtb" {
  vpc_id = aws_vpc.web_vpc.id

  tags = merge({
    Name = "${local.resource_prefix.value}-rtb"
    }, {
    git_last_modified_by = "email@email.com"
    git_modifiers        = "foo.bar"
    git_org              = "checkmarx"
    git_repo             = "kics"
  })
}

resource "aws_route_table_association" "rtbassoc" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.web_rtb.id
}

resource "aws_route_table_association" "rtbassoc2" {
  subnet_id      = aws_subnet.web_subnet2.id
  route_table_id = aws_route_table.web_rtb.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.web_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web_igw.id

  timeouts {
    create = "5m"
  }
}


resource "aws_network_interface" "web-eni" {
  subnet_id   = aws_subnet.web_subnet.id
  private_ips = ["172.16.10.100"]

  tags = merge({
    Name = "${local.resource_prefix.value}-primary_network_interface"
    }, {
    git_last_modified_by = "email@email.com"
    git_modifiers        = "foo.bar"
    git_org              = "checkmarx"
    git_repo             = "kics"
  })
}

# VPC Flow Logs to S3
resource "aws_flow_log" "vpcflowlogs" {
  log_destination      = aws_s3_bucket.flowbucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.web_vpc.id

  tags = merge({
    Name        = "${local.resource_prefix.value}-flowlogs"
    Environment = local.resource_prefix.value
    }, {
    git_last_modified_by = "email@email.com"
    git_modifiers        = "foo.bar"
    git_org              = "checkmarx"
    git_repo             = "kics"
  })
}

resource "aws_s3_bucket" "flowbucket" {
  bucket        = "${local.resource_prefix.value}-flowlogs"
  force_destroy = true

  tags = merge({
    Name        = "${local.resource_prefix.value}-flowlogs"
    Environment = local.resource_prefix.value
    }, {
    git_last_modified_by = "email@email.com"
    git_modifiers        = "foo.bar"
    git_org              = "checkmarx"
    git_repo             = "kics"
  })
}

output "ec2_public_dns" {
  description = "Web Host Public DNS name"
  value       = aws_instance.web_host.public_dns
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.web_vpc.id
}

output "public_subnet" {
  description = "The ID of the Public subnet"
  value       = aws_subnet.web_subnet.id
}

output "public_subnet2" {
  description = "The ID of the Public subnet"
  value       = aws_subnet.web_subnet2.id
}

```
</details>
<details><summary>Positive test num. 8 - yaml file</summary>

```yaml hl_lines="34 36"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: x
spec:
  replicas: 5
  selector:
    matchLabels:
      app: x
  template:
    metadata:
      labels:
        app: x
    spec:
      containers:
        - name: x
          image: x
          ports:
            - containerPort: 5432
          env:
            - name: PORT
              value: "1234"
            - name: DB_HOST
              value: "127.0.0.1"
            - name: DB_PORT
              value: "23"
            - name: DB_PORT_BD
              value: "5432"
            - name: DB_HOST_BD
              value: "127.0.0.1"
            - name: DB_NAME_BD
              value: "dbx"
            - name: DB_PASS_BD
              value: "passx"
            - name: DB_PASS_BD_2
              value: "passx"
            - name: DB_USER_BD
              value: "userx"

```
</details>
<details><summary>Positive test num. 9 - tf file</summary>

```tf hl_lines="7"
resource "azurerm_sql_server" "example" {
  name                         = "kics-test"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "ariel"
  administrator_login_password = "Aa12345678"

  tags = {
    environment = var.environment
    terragoat   = "true"
  }
}

```
</details>
<details><summary>Positive test num. 10 - tf file</summary>

```tf hl_lines="5"
resource "auth0_connection" "google_oauth2" {
  name = "Google-OAuth2-Connection"
  strategy = "google-oauth2"
  options {
    client_id = "53221331-2323wasdfa343rwhthfaf33feaf2fa7f.apps.googleusercontent.com"
    client_secret = "j2323232324"
    allowed_audiences = [ "example.com", "api.example.com" ]
    scopes = [ "email", "profile", "gmail", "youtube" ]
    set_user_root_attributes = "on_each_login"
  }
}

```
</details>
<details><summary>Positive test num. 11 - tf file</summary>

```tf hl_lines="2"
provider "slack" {
  token = "xoxp-121314151623-121314151623-121314151623-12131423121314151623121314151623"
}

```
</details>
<details><summary>Positive test num. 12 - yaml file</summary>

```yaml hl_lines="6"
#cloud formation test
Resources:
  RDSCluster1:
    Type: "AWS::RDS::DBCluster"
    Properties:
      MasterUserPassword: root
      DBClusterIdentifier: my-serverless-cluster
      Engine: aurora
      EngineVersion: 5.6.10a
      EngineMode: serverless
      ScalingConfiguration:
        AutoPause: true
        MinCapacity: 4
        MaxCapacity: 32
        SecondsUntilAutoPause: 1000

```
</details>
<details><summary>Positive test num. 13 - tf file</summary>

```tf hl_lines="2"
provider "stripe" {
  api_key = "sk_live_aSaDsEaSaDsEaSaDs29SaDsE"
}

```
</details>
<details><summary>Positive test num. 14 - tf file</summary>

```tf hl_lines="50"
resource "aws_ecs_task_definition" "webapp" {
  family        = "tomato-webapp"
  task_role_arn = data.aws_iam_role.ecs_task_role.arn

  container_definitions = <<EOF
[
  {
    "volumesFrom": [],
    "extraHosts": null,
    "dnsServers": null,
    "disableNetworking": null,
    "dnsSearchDomains": null,
    "portMappings": [
      {
        "hostPort": 0,
        "containerPort": 8000,
        "protocol": "tcp"
      }
    ],
    "hostname": null,
    "essential": true,
    "entryPoint": null,
    "mountPoints": [],
    "name": "tomato",
    "ulimits": null,
    "dockerSecurityOptions": null,
    "environment": [
      {
        "name": "RDS_HOST",
        "value": "${aws_db_instance.tomato.address}"
      },
      {
        "name": "RDS_NAME",
        "value": "${aws_db_instance.tomato.name}"
      },
      {
        "name": "RDS_USER",
        "value": "${aws_db_instance.tomato.username}"
      },
      {
        "name": "RDS_PASSWORD",
        "value": "${aws_db_instance.tomato.password}"
      },
      {
        "name": "RDS_PORT",
        "value": "${aws_db_instance.tomato.port}"
      },
      {
        "name": "GOOGLE_MAPS_API_KEY",
        "value": "AIzaSyD4BPAvDHL4CiRcFORdoUCpqwVuVz1F9r8"
      },
      {
        "name": "SECRET_KEY",
        "value": "${var.secret_key}"
      }
    ],
    "workingDirectory": "/code",
    "readonlyRootFilesystem": null,
    "image": "${aws_ecr_repository.tomato.repository_url}:latest",
    "command": [
      "sh",
      "-c",
      "python3 manage.py initialize && uwsgi --ini /code/uwsgi.ini"
    ],
    "user": null,
    "dockerLabels": null,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.tomato_webapp.name}",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "webapp"
      }
    },
    "cpu": 700,
    "privileged": null,
    "memoryReservation": 512,
    "linuxParameters": {
      "initProcessEnabled": true
    }
  }
]
EOF

}

```
</details>
<details><summary>Positive test num. 15 - tf file</summary>

```tf hl_lines="3"
provider "heroku" {
  email   = "ops@company.com"
  api_key = "C71AAAAE-1D1D-1D1D-1D1D-1D1D1D1D1D1D"
}

```
</details>
<details><summary>Positive test num. 16 - tf file</summary>

```tf hl_lines="3"

provider "github" {
   token = "we2323232g3hg2h3g2h3g2h3g2h3uh2h3ghg32h3"
}

```
</details>
<details><summary>Positive test num. 17 - tf file</summary>

```tf hl_lines="4"
provider "cloudflare" {
  version = "~> 2.0"
  email   = "var.cloudflare_email"
  api_key = "1d2d2dewerdcxeee34c323c3223c223232c32"
}

```
</details>
<details><summary>Positive test num. 18 - dockerfile file</summary>

```dockerfile hl_lines="3 5 7 9 11"
FROM baseImage

ARG token=sq0atp-812erere3wewew45678901

ARG picaticKey=sk_live_123as6789o1234567890123a123a5678

ARG amazonToken=amzn.mws.643a5678-8f9f-1a2b-5c3b-e3ea43f3f4b4

ARG mailChimp=f4f56af5a54a3eaeb3c3beb3cc2ccccc-us36

ARG sgApiK=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

```
</details>
<details><summary>Positive test num. 19 - yaml file</summary>

```yaml hl_lines="9"
Resources:
  PinpointApp:
    Type: AWS::Pinpoint::App
    Properties:
      Name: foobar
  PinpointAPNSChannel:
    Type: AWS::Pinpoint::APNSChannel
    Properties:
      PrivateKey: b@d0@u7H70K3n

```
</details>
<details><summary>Positive test num. 20 - yaml file</summary>

```yaml hl_lines="5 22"
Resources:
  ElastiCacheReplicationGroup:
    Type: AWS::ElastiCache::ReplicationGroup
    Properties:
      AuthToken: b@d0@u7H70K3n
      CacheNodeType: cache.m5.large
      CacheSubnetGroupName: subnet-foobar
      Engine: redis
      EngineVersion: '5.0.0'
      NumCacheClusters: 2
      ReplicationGroupDescription: foobar
      SecurityGroupIds:
        - sg-foobar
      TransitEncryptionEnabled: True
  PinpointApp:
    Type: AWS::Pinpoint::App
    Properties:
      Name: foobar
  PinpointAPNSChannel:
    Type: AWS::Pinpoint::APNSChannel
    Properties:
      TokenKey: b@d0@u7H70K3n
      ApplicationId: !Ref PinpointApp

```
</details>
<details><summary>Positive test num. 21 - yaml file</summary>

```yaml hl_lines="5"
- name: Start a workflow in the Itential Automation Platform
  community.network.iap_start_workflow:
    iap_port: 3000
    iap_fqdn: localhost
    token_key: "DFSFSFHFGFGF[DSFSFAADAFASD%3D"
    workflow_name: "RouterUpgradeWorkflow"
    description: "OS-Router-Upgrade"
    variables: {"deviceName":"ASR9K"}
  register: result

```
</details>
<details><summary>Positive test num. 22 - tf file</summary>

```tf hl_lines="2"
provider "mailgun" {
  api_key = "key-987ad62adwf1w2w2563adf2ef5323123"
}

```
</details>
<details><summary>Positive test num. 23 - yaml file</summary>

```yaml hl_lines="7"
#ansible test
- name: create a cluster1
  google.cloud.gcp_container_cluster:
    name: my-cluster1
    initial_node_count: 2
    master_auth:
      password: root
    node_config:
      machine_type: n1-standard-4
      disk_size_gb: 500
    location: us-central1-a
    project: test_project
    auth_kind: serviceaccount
    service_account_file: "/tmp/auth.pem"
    state: present

```
</details>
<details><summary>Positive test num. 24 - tf file</summary>

```tf hl_lines="2"
provider "stripe" {
  api_key = "rk_live_aSaDsEaSaDsEaSaDs29SaDsE"
}

```
</details>
<details><summary>Positive test num. 25 - yaml file</summary>

```yaml hl_lines="4"
- hosts: all
  remote_user: root
  vars:
    twilio_api_key: SKa7CF7acdcaf92Be4CCC52F4a2923BBB3


```
</details>
<details><summary>Positive test num. 26 - yaml file</summary>

```yaml hl_lines="4"
- hosts: all
  remote_user: root
  vars:
    paypal_access_token: access_token$production$1s2d3f4g5h6j7k8k$1b2b3c4a3a1b2b3c4a3a1b2b3c4a3a1b


```
</details>
<details><summary>Positive test num. 27 - yaml file</summary>

```yaml hl_lines="13"
apiVersion: v1
kind: Pod
metadata:
  name: envar-demo
  labels:
    purpose: demonstrate-envars
spec:
  containers:
  - name: envar-demo-container
    image: gcr.io/google-samples/node-hello:1.0
    env:
    - name: FACEBOOK_TOKEN
      value: "EAACEdEose0cBA1bad3afsf2aew"


```
</details>
<details><summary>Positive test num. 28 - yaml file</summary>

```yaml hl_lines="13"
apiVersion: v1
kind: Pod
metadata:
  name: envar-demo
  labels:
    purpose: demonstrate-envars
spec:
  containers:
  - name: envar-demo-container
    image: gcr.io/google-samples/node-hello:1.0
    env:
    - name: Square_OAuth_Secret
      value: "sq0csp-0p9h7g6f4s3s3s3-4a3ardgwa6ADRDJDDKUFYDYDYDY"


```
</details>
<details><summary>Positive test num. 29 - yaml file</summary>

```yaml hl_lines="13"
apiVersion: v1
kind: Config
users:
- name: cluster-admin
  user:
    auth-provider:
      config: {}
      name: gcp
- name: google-oauth-access-token
  user:
    auth-provider:
      config:
        access-token: ya29.Radftwefewuifdebkw2_23232427t42wdbjsvdjavdajvdadkd
        cmd-args: config config-helper --format=json
        cmd-path: /Users/dave/google-cloud-sdk/bin/gcloud
        expiry: 2021-10-28T15:12:03.000Z
        expiry-key: '{.credential.token_expiry}'
        token-key: '{.credential.access_token}'
      name: gcp

```
</details>
<details><summary>Positive test num. 30 - tf file</summary>

```tf hl_lines="5"
resource "aws_transfer_ssh_key" "example2" {
	server_id = aws_transfer_server.example.id
	user_name = aws_transfer_user.example.user_name
	body      = <<EOF
"PuTTY-User-Key-File-2: ssh-rsa
Encryption: none
Comment: rsa-key-20200108
Public-Lines: 6
AAAAB3NzaC1yc2EAAAABJQAAAQEAqAqCgv1dG+bcrnuqj39WYgCCGT8lYNe31Ak1
nIyZ38Nocz4YRQ6dRizmr4SSO7J1+py1aOLttCI50gZjtqXl2ZhItkihETdWW4Sw
8WirLI1s8RdycWu4pwidUabiOEiOfP5Bh+1kwWXrC/BX0Fxjl0RNSKTTT4jJZLDy
io5INi8NXmrTTc3rzy90uQrip3nVBSwuQtCJSAr8yrXSf5hJ9plKUt2iC5TCKXdS
1nnF4DddNM5wjTX24NXsF1JFsI1qpXYoGSF7mHDzreNS70Vn75sOk3HwQ7MtZWyy
+kR2ZewwtUaODj4xLNGawERjpwbOtdaJdHtmh0sP6MCdopd3RQ==
Private-Lines: 14
AAABAGz/5fQZ9zSxbIzamCW6YYutTXgo9aaZw1kauv3C/AbD8Ll0YsUCj4d3Eiyp
BOhzwiYEyLK8tdyglDU0k7S+ou4B6fmykf1UU7D8H78vIux3aUJwEuHJVS4TbPax
cCSCFzxR5VFACgDoKcKOD3JlcQgsTc5BZnjHbeByxtZqIQCMK5KGq+dHP/oYLWwr
mtxU3GiMr/qiLUwh9C7Lgo+ZmsbYxxGUf4wx2W26sPsNW9AVZT7hGSW/KxpzufZW
lcF5b+WOt1LtnJKKqj1HiSTxPFIED1iEpppo4+HW6ikiZcEsGNU0pPK8T4C/l045
8Ff7cAzSuEoWdQ9zxHS6SM8ngK0AAACBANvnhGzvvVkpSdz2hRGGPVuZAXexIU7P
R8E7Fdut3x5Slly1mwxcZ1lp/92ZSXStJyPjEerSj/1Hhs4qSDbLKiBpfA1CY2Jo
FaePO7J8dxySMwurE8dMzoZjFNsmAkYLONuWY7yarmBzE5hvdcrOyljQmAih0YrC
SZp2wzDpxmd9AAAAgQDDn6wdWYK6rwBRu8KXuDmloFHR70qJ+LmNx3uNiaxdBsoQ
DNL7tws5i6JPD3u4/O89O3bUSx9B0IdfO+89Wx1oZL4VjDpyeRrbAC6tBIUOXvcV
6pGoHi2dBiyEKi0o0OSu1jGofVgrfev5DYqbpe4pJs76CxyR99mmk148eXQpaQAA
AIEAld+qxTyO3unJrAg8JOnFLoLZ7wk0lyN0UyzuRp7c6HYPqrrdOWktGAVHPXVP
olYDB4PYZoNtjJgLvZhVIFtUEVk5y6swaRA6jde+363UXZZEKS5ZIi7Acgownv4Z
7nPANzK0ZdsZELEVR9kSB/Z690LV2IKovh9bAbmhveEcMLQ=
Private-MAC: 8d9cbf92b0e8f23309a9ebea525aae27d4fdbbdd"
EOF
}

```
</details>
<details><summary>Positive test num. 31 - tf file</summary>

```tf hl_lines="14"
resource "aws_lambda_function" "analysis_lambda2" {
  # lambda have plain text secrets in environment variables
  filename      = "resources/lambda_function_payload.zip"
  function_name = "${local.resource_prefix.value}-analysis"
  role          = "aws_iam_role.iam_for_lambda.arn"
  handler       = "exports.test"

  source_code_hash = "${filebase64sha256("resources/lambda_function_payload.zip")}"

  runtime = "nodejs12.x"

  environment {
    variables = {
      secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
    }
  }
}

```
</details>
<details><summary>Positive test num. 32 - yaml file</summary>

```yaml hl_lines="16"
Resources:
     NewAmpApp2:
        Type: AWS::DocDB::DBCluster
        Properties:
          MasterUserPassword: !Sub '{{resolve:secretsmanager:${MyAmpAppSecretManagerRotater}::password}}'
          Port: 27017
          PreferredBackupWindow: "07:34-08:04"
          PreferredMaintenanceWindow: "sat:04:51-sat:05:21"
          SnapshotIdentifier: "sample-cluster-snapshot-id"
          StorageEncrypted: true
     MyAmpAppSecretManagerRotater:
        Type: AWS::SecretsManager::Secret
        Properties:
          Description: 'This is my amp app instance secret'
          GenerateSecretString:
            SecretStringTemplate: '{"username":"admin"}'
            GenerateStringKey: 'password'
            PasswordLength: 16
            ExcludeCharacters: '"@/\'

```
</details>
<details><summary>Positive test num. 33 - tf file</summary>

```tf hl_lines="3"
locals {
  secrets = {
    clientSecret = "C98D9F6O-1273-4E8A-B8D9-551F7F3OC41"
  }
}

```
</details>
<details><summary>Positive test num. 34 - tf file</summary>

```tf hl_lines="9"
#this is a problematic code where the query should report a result(s)
resource "google_container_cluster" "primary1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = "root"

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

```
</details>
<details><summary>Positive test num. 35 - tf file</summary>

```tf hl_lines="14 15"
resource "aws_instance" "web_host" {
  # ec2 have plain text secrets in user data
  ami           = var.ami
  instance_type = "t2.nano"

  vpc_security_group_ids = ["aws_security_group.web-node.id"]
  subnet_id = aws_subnet.web_subnet.id
  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
export AWS_CONTEXT_CREDENTIAL=ACCAIOSFODNN7EXAMAAA
export AWS_CERTIFICATE=ASCAIOSFODNN7EXAMAAA
export AWS_DEFAULT_REGION=us-west-2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF
  tags = merge({
    Name = "${local.resource_prefix.value}-ec2"
    }, {
    git_last_modified_by = "email@email.com"
    git_modifiers        = "foo.bar"
    git_org              = "checkmarx"
    git_repo             = "kics"
  })
}

```
</details>
<details><summary>Positive test num. 36 - tf file</summary>

```tf hl_lines="6"
resource "aws_transfer_ssh_key" "positive44" {
	server_id = aws_transfer_server.example.id
	user_name = aws_transfer_user.example.user_name
	body      = <<EOT
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,XXXXXXXXXXXXXX

b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAaAAAABNlY2RzYS
1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTTD+Q+10oNWDzXxx9x2bOobcXAA4rd
jGaQoqJjcXRWR2TS1ioKvML1fI5KLP4kuF3TlyPTLgJxlfrJtYYEfGHwAAAA0FjbkWRY25
FkAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNMP5D7XSg1YPNfH
H3HZs6htxcADit2MZpCiomNxdFZHZNLWKgq8wvV8jkos/iS4XdOXI9MuAnGV+sm1hgR8Yf
AAAAAgHI23o+KRbewZJJxFExEGwiOPwM7gonjATdzLP+YT/6sAAAA0cm9nZXJpb3AtbWFj
Ym9va0BSb2dlcmlvUC1NYWNCb29rcy1NYWNCb29rLVByby5sb2NhbAECAwQ=
-----END RSA PRIVATE KEY-----
EOT
}

```
</details>
<details><summary>Positive test num. 37 - tf file</summary>

```tf hl_lines="7"
data "terraform_remote_state" "intnet" {
  backend = "azurerm"
  config = {
    storage_account_name = "asdsadas"
    container_name       = "dp-prasdasdase-001"
    key                  = "infrastructure.tfstate"
    access_key           = "sdsaljasbdasddsadsa"
  }
  workspace = terraform.workspace
}

```
</details>
<details><summary>Positive test num. 38 - yaml file</summary>

```yaml hl_lines="5"
Resources:
  ElastiCacheReplicationGroup:
    Type: AWS::ElastiCache::ReplicationGroup
    Properties:
      AuthToken: '{{resolve:secretsmanager:/elasticache/replicationgroup/authtoken:SecretString:password}}'
      CacheNodeType: cache.m5.large
      CacheSubnetGroupName: subnet-foobar
      Engine: redis
      EngineVersion: '5.0.0'
      NumCacheClusters: 2
      ReplicationGroupDescription: foobar
      SecurityGroupIds:
        - sg-foobar
      TransitEncryptionEnabled: True

```
</details>
<details><summary>Positive test num. 39 - yaml file</summary>

```yaml hl_lines="17"
Transform: 'AWS::Serverless-2016-10-31'
Metadata:
  'AWS::ServerlessRepo::Application':
    Name: AthenaJdbcConnector
    Description: 'This connector enables Amazon Athena to communicate with your Database instance(s) using JDBC driver.'
    Author: 'default author'
    SpdxLicenseId: Apache-2.0
    LicenseUrl: LICENSE.txt
    ReadmeUrl: README.md
    Labels:
      - athena-federation
    HomePageUrl: 'https://github.com/awslabs/aws-athena-query-federation'
    SemanticVersion: 2021.41.1
    SourceCodeUrl: 'https://github.com/awslabs/aws-athena-query-federation'
Parameters:
  SecretNamePrefix:
      Description: 'Used to create resource-based authorization policy for "secretsmanager:GetSecretValue" action. E.g. All Athena JDBC Federation secret names can be prefixed with "AthenaJdbcFederation" and authorization policy will allow "arn:${AWS::Partition}:secretsmanager:${AWS::Region}:${AWS::AccountId}:secret:AthenaJdbcFederatione*". Parameter value in this case should be "AthenaJdbcFederation". If you do not have a prefix, you can manually update the IAM policy to add allow any secret names.'
      Type: String
Resources:
```
</details>
<details><summary>Positive test num. 40 - tf file</summary>

```tf hl_lines="9"
#this is a problematic code where the query should report a result(s)
resource "google_container_cluster" "primary1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = local.rds_postgres_is_primary ? var.rds_postgres_password : "null"

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

```
</details>
<details><summary>Positive test num. 41 - yaml file</summary>

```yaml hl_lines="20 21"
version: '3.9'
services:
  vulnerable_node:
    restart: always
    build: .
    depends_on:
      - postgres_db
    ports:
      - "3000:3000"
    depends_on:
      - postgres_db

  postgres_db:
    restart: always
    build: ./services/postgresql
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_PASSWORD=string

```
</details>
<details><summary>Positive test num. 42 - tf file</summary>

```tf hl_lines="5 6"
resource "auth0_connection" "google_oauth2" {
  name = "Google-OAuth2-Connection"
  strategy = "google-oauth2"
  options {
    client_id = "53221331-2323wasdfa343rwhthfaf33feaf2fa7f.apps.googleusercontent.com"
    client_secret = "F-oS9Su%}<>[];#"
    allowed_audiences = [ "example.com", "api.example.com" ]
    scopes = [ "email", "profile", "gmail", "youtube" ]
    set_user_root_attributes = "on_each_login"
  }
}

```
</details>
<details><summary>Positive test num. 43 - tf file</summary>

```tf hl_lines="8"
resource "google_container_cluster" "primary1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = "varexample"

    client_certificate_config {
      issue_client_certificate = true
      password = var.example
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

```
</details>
<details><summary>Positive test num. 44 - yml file</summary>

```yml hl_lines="7"
on: workflow_call

stages:
  - build

variables:
  GIT_PRIVATE_KEY: "heythisisaprivatekey!"

jobs:
  job_build:
    stage: build
    script:
      - if [[ -z "${GIT_PRIVATE_KEY:-}" ]]; then
          echo "Missing GIT_PRIVATE_KEY variable!"
          exit 1
        fi
      - echo "Private key is set."

    steps:
      - uses: actions/checkout@v4
```
</details>
<details><summary>Positive test num. 45 - tf file</summary>

```tf hl_lines="2"
resource "google_secret_manager_secret_version" "secret-version-basic2" {
  secret = "3gzcGokilvtw2HmCLuPx"

  secret_data = "secret-data"
}

```
</details>
<details><summary>Positive test num. 46 - yaml file</summary>

```yaml hl_lines="56 68"
swagger: "2.0"
info:
  x-ibm-name: sirene-apigw
  title: Sirene
  description: '{reflex-name:DIALOG/APFR}{contacts:J594670}'
  version: 1.0.0
  contact:
    email: mickael.masse@mpsa.com
    name: MICKAEL MASSE
schemes:
  - https
basePath: /partners/dialog-apfr/sirene/v1
consumes:
  - application/json
produces:
  - application/json
securityDefinitions:
  Basic Authentication:
    description: The user name and password provided by PSA Group.
    type: basic
    x-ibm-authentication-registry: ldap
  Client ID:
    description: The client ID provided by PSA Group when you register your application.
    in: header
    name: X-IBM-Client-Id
    type: apiKey
security:
  - Client ID: []
x-ibm-configuration:
  testable: true
  enforced: true
  cors:
    enabled: true
  assembly:
    execute:
      - parse:
          version: 2.0.0
          use-content-type: true
          warn-on-empty-input: true
      - gatewayscript:
          title: set target url
          version: 1.0.0
      - invoke:
          title: invoke
          verb: keep
          target-url: $(target-url)$(api.operation.path)
          version: 1.5.0
          final-action: true
  gateway: datapower-api-gateway
  properties:
    mock-proxy-user:
      value: mzpamt66
      description: ""
      encoded: false
    mock-proxy-password:
      value: testpwd
      description: ""
      encoded: false
    mock-target-url:
      value: https://api.insee.fr/entreprises/sirene/V3
      description: ""
      encoded: false
    dev-proxy-user:
      value: mzpamt66
      description: ""
      encoded: false
    dev-proxy-password:
      value: testpwd
      description: ""
      encoded: false
    dev-target-url:
      value: https://api.insee.fr/entreprises/sirene/V3
      description: ""
      encoded: false
    preprod-target-url:
      value: REPLACE_PREPROD_URL
      description: ""
      encoded: false
    prod-target-url:
      value: REPLACE_PROD_URL
      description: ""
      encoded: false
  phase: realized
  type: rest
  compatibility:
    wrapper-policies:
      allow-chunked-uploads: false
    enforce-required-params: false
    request-headers: true
    allow-trailing-slash: true
    migrated-api: true
  buffering: true
paths:
  /siren:
    post:
      tags:
        - UniteLegale
      summary: Recherche multicritère d'unités légales
      description: ""
      operationId: findSirenByQPost
      consumes:
        - application/x-www-form-urlencoded
      produces:
        - application/json
        - text/csv
      parameters:
        - name: q
          in: formData
          description: Contenu de la requête multicritères, voir la documentation pour
            plus de précisions
          required: false
          type: string
        - name: date
          in: formData
          description: Date à laquelle s'appliqueront les critères de recherche sur
            les champs historisés, format AAAA-MM-JJ
          required: false
          type: string
        - name: champs
          in: formData
          description: Liste des champs demandés, séparés par des virgules
          required: false
          type: string
        - name: masquerValeursNulles
          in: formData
          description: Masque (true) ou affiche (false, par défaut) les attributs qui
            n'ont pas de valeur
          required: false
          type: boolean
        - name: facette.champ
          in: formData
          description: Liste des champs sur lesquels des comptages seront effectués,
            séparés par des virgules
          required: false
          type: string
        - name: tri
          in: formData
          description: Champs sur lesquels des tris seront effectués, séparés par des
            virgules. Tri sur siren par défaut
          required: false
          type: string
        - name: nombre
          in: formData
          description: Nombre d'éléments demandés dans la réponse, défaut 20
          required: false
          type: integer
          maximum: 100000
          minimum: 0
        - name: debut
          in: formData
          description: Rang du premier élément demandé dans la réponse, défaut 0
          required: false
          type: integer
          maximum: 1000000
          minimum: 0
        - name: curseur
          in: formData
          description: Paramètre utilisé pour la pagination profonde, voir la documentation
            pour plus de précisions
          required: false
          type: string
      responses:
        "200":
          description: successful operation
          schema:
            $ref: '#/definitions/ReponseUnitesLegales'
        "301":
          description: Entreprise doublon
        "400":
          description: Nombre incorrect de paramètres ou les paramètres sont mal formatés
        "401":
          description: Jeton d'accès manquant ou invalide
        "404":
          description: Entreprise non trouvée dans la base Sirene (si le paramètre
            date n'a pas été utilisé, cela peut signifier que le numéro de 9 chiffres
            ne correspond pas à un Siren présent dans la base ; si le paramètre a
            été utilisé, le Siren peut exister mais la date de création est postérieure
            au paramètre date)
        "406":
          description: Le paramètre 'Accept' de l'en-tête HTTP contient une valeur
            non prévue
        "414":
          description: Requête trop longue
        "429":
          description: Quota d'interrogations de l'API dépassé
        "500":
          description: Erreur interne du serveur
        "503":
          description: Service indisponible
      x-auth-type: Application & Application User
      x-throttling-tier: Unlimited
    get:
      tags:
        - Informations
      summary: État du service, dates de mise à jour et numéro de version
      description: ""
      operationId: informations
      produces:
        - application/json
      parameters: []
      responses:
        "200":
          description: successful operation
          schema:
            $ref: '#/definitions/ReponseInformations'
        "503":
          description: Service indisponible
      x-auth-type: Application & Application User
      x-throttling-tier: Unlimited
definitions:
  Adresse:
    type: object
    properties:
      complementAdresseEtablissement:
        type: string
        description: Complément d'adresse de l'établissement
      numeroVoieEtablissement:
        type: string
        description: Numéro dans la voie
      indiceRepetitionEtablissement:
        type: string
        description: Indice de répétition dans la voie
      typeVoieEtablissement:
        type: string
        description: Type de la voie
      libelleVoieEtablissement:
        type: string
        description: Libellé de la voie
      codePostalEtablissement:
        type: string
        description: Code postal
      libelleCommuneEtablissement:
        type: string
        description: Libellé de la commune pour les adresses en France
      libelleCommuneEtrangerEtablissement:
        type: string
        description: Libellé complémentaire pour une adresse à l'étranger
      distributionSpecialeEtablissement:
        type: string
        description: Distribution spéciale (BP par ex)
      codeCommuneEtablissement:
        type: string
        description: Code commune de localisation de l’établissement hors établissements
          situés à l’étranger (Le code commune est défini dans le <a href='https://www.insee.fr/fr/information/2028028'>code
          officiel géographique (COG)</a>)
      codeCedexEtablissement:
        type: string
        description: Numéro de Cedex
      libelleCedexEtablissement:
        type: string
        description: Libellé correspondant au numéro de Cedex (variable codeCedexEtablissement)
      codePaysEtrangerEtablissement:
        type: string
        description: Code pays pour les établissements situés à l’étranger
      libellePaysEtrangerEtablissement:
        type: string
        description: Libellé du pays pour les adresses à l’étranger
    description: Ensemble des variables d'adresse d'un établissement
    etatService:
      type: string
      description: État actuel du service
      enum:
        - UP
        - DOWN
tags: []

```
</details>
<details><summary>Positive test num. 47 - dockerfile file</summary>

```dockerfile hl_lines="4"
FROM baseImage

ENV ARTEMIS_USER artemis
ENV ARTEMIS_PASSWORD artemis

RUN apk add --no-cache git \
    && git config \
    --global \
    url."https://${GIT_USER}:${GIT_TOKEN}@github.com".insteadOf \
    "https://github.com"

```
</details>
<details><summary>Positive test num. 48 - dockerfile file</summary>

```dockerfile hl_lines="4"
FROM baseImage

ENV ARTEMIS_USER=artemis
ENV ARTEMIS_PASSWORD=artemis

RUN apk add --no-cache git \
    && git config \
    --global \
    url."https://${GIT_USER}:${GIT_TOKEN}@github.com".insteadOf \
    "https://github.com"

```
</details>
<details><summary>Positive test num. 49 - json file</summary>

```json hl_lines="54"
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "siteName": {
      "type": "string"
    },
    "administratorLogin": {
      "type": "string"
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]"
    }
  },
  "variables": {
    "databaseName": "[concat(parameters('siteName'), 'db')]",
    "serverName": "[concat(parameters('siteName'), 'srv')]",
    "hostingPlanName": "[concat(parameters('siteName'), 'plan')]"
  },
  "resources": [
    {
      "type": "Microsoft.Web/serverfarms",
      "apiVersion": "2020-06-01",
      "name": "[variables('hostingPlanName')]",
      "location": "[parameters('location')]",
      "sku": {
        "Tier": "Standard",
        "Name": "S1"
      },
      "properties": {}
    },
    {
      "type": "Microsoft.Web/sites",
      "apiVersion": "2020-06-01",
      "name": "[parameters('siteName')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Web/serverfarms', variables('hostingPlanName'))]"
      ],
      "properties": {
        "serverFarmId": "[variables('hostingPlanName')]"
      },
      "resources": [
        {
          "type": "config",
          "apiVersion": "2020-06-01",
          "name": "connectionstrings",
          "dependsOn": [
            "[resourceId('Microsoft.Web/sites', parameters('siteName'))]"
          ],
          "properties": {
            "defaultConnection": {
              "value": "[concat('Database=', variables('databaseName'), ';Data Source=', reference(resourceId('Microsoft.DBforMySQL/servers', variables('serverName'))).fullyQualifiedDomainName, ';User Id=', parameters('administratorLogin'), '@', variables('serverName'), ';Password=HardCodedP@ssw0rd!')]",
              "type": "MySql"
            }
          }
        }
      ]
    }
  ]
}

```
</details>
<details><summary>Positive test num. 50 - dockerfile file</summary>

```dockerfile hl_lines="3 7"
FROM baseImage

ARG password=pass!1213Fs


FROM test2
ARG password=pass!1213Fs

```
</details>
<details><summary>Positive test num. 51 - tf file</summary>

```tf hl_lines="8"
resource "google_container_cluster" "primary2" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = "pwd_jsuwauJk212"

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

```
</details>
<details><summary>Positive test num. 52 - json file</summary>

```json hl_lines="4 7"
{
  "Resources": {
    "service-1": {
      "password": "abcdefg"
    },
    "service-2": {
      "password": "abcdefg"
    }
  }
}

```
</details>
<details><summary>Positive test num. 53 - tf file</summary>

```tf hl_lines="8"
resource "google_container_cluster" "primary4" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = "abcd    s"

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

```
</details>


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
#k8s test
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    env: test
spec:
  containers:
    - name: nginx
      image: nginx
      # trigger validation

```
```tf title="Negative test num. 2 - tf file"
resource "aws_db_instance" "default" {
  name                   = var.dbname
  engine                 = "mysql"
  option_group_name      = aws_db_option_group.default.name
  parameter_group_name   = aws_db_parameter_group.default.name
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = ["aws_security_group.default.id"]
  identifier              = "rds-${local.resource_prefix.value}"
  engine_version          = "8.0" # Latest major version
  instance_class          = "db.t3.micro"
  allocated_storage       = "20"
  username                = "admin"
  password                = var.password
  apply_immediately       = true
  multi_az                = false
  backup_retention_period = 0
  storage_encrypted       = false
  skip_final_snapshot     = true
  monitoring_interval     = 0
  publicly_accessible     = true
  tags = {
    Name        = "${local.resource_prefix.value}-rds"
    Environment = local.resource_prefix.value
  }

  # Ignore password changes from tf plan diff
  lifecycle {
    ignore_changes = ["password"]
  }
}

```
```tf title="Negative test num. 3 - tf file"
resource "auth0_connection" "google_oauth2" {
  name = "Google-OAuth2-Connection"
  strategy = "google-oauth2"
  options {
    client_id     = var.google_client_id
    client_secret = var.google_client_secret
    allowed_audiences = [ "example.com", "api.example.com" ]
    scopes = [ "email", "profile", "gmail", "youtube" ]
    set_user_root_attributes = "on_each_login"
  }
}

```
<details><summary>Negative test num. 4 - tf file</summary>

```tf
provider "slack" {
  token = var.slack_token
}

```
</details>
<details><summary>Negative test num. 5 - tf file</summary>

```tf
provider "stripe" {
  api_key = var.strip_api_key
}

```
</details>
<details><summary>Negative test num. 6 - tf file</summary>

```tf
resource "aws_ecs_task_definition" "webapp" {
  family        = "tomato-webapp"
  task_role_arn = data.aws_iam_role.ecs_task_role.arn

  container_definitions = <<EOF
[
  {
    "volumesFrom": [],
    "extraHosts": null,
    "dnsServers": null,
    "disableNetworking": null,
    "dnsSearchDomains": null,
    "portMappings": [
      {
        "hostPort": 0,
        "containerPort": 8000,
        "protocol": "tcp"
      }
    ],
    "hostname": null,
    "essential": true,
    "entryPoint": null,
    "mountPoints": [],
    "name": "tomato",
    "ulimits": null,
    "dockerSecurityOptions": null,
    "environment": [
      {
        "name": "RDS_HOST",
        "value": "${aws_db_instance.tomato.address}"
      },
      {
        "name": "RDS_NAME",
        "value": "${aws_db_instance.tomato.name}"
      },
      {
        "name": "RDS_USER",
        "value": "${aws_db_instance.tomato.username}"
      },
      {
        "name": "RDS_PASSWORD",
        "value": "${aws_db_instance.tomato.password}"
      },
      {
        "name": "RDS_PORT",
        "value": "${aws_db_instance.tomato.port}"
      },
      {
        "name": "GOOGLE_MAPS_API_KEY",
        "value": "${var.google_maps_api_key}"
      },
      {
        "name": "SECRET_KEY",
        "value": "${var.secret_key}"
      }
    ],
    "workingDirectory": "/code",
    "readonlyRootFilesystem": null,
    "image": "${aws_ecr_repository.tomato.repository_url}:latest",
    "command": [
      "sh",
      "-c",
      "python3 manage.py initialize && uwsgi --ini /code/uwsgi.ini"
    ],
    "user": null,
    "dockerLabels": null,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.tomato_webapp.name}",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "webapp"
      }
    },
    "cpu": 700,
    "privileged": null,
    "memoryReservation": 512,
    "linuxParameters": {
      "initProcessEnabled": true
    }
  }
]
EOF

}

```
</details>
<details><summary>Negative test num. 7 - tf file</summary>

```tf
provider "heroku" {
  email   = "ops@company.com"
  api_key = var.heroku_api_key
}

```
</details>
<details><summary>Negative test num. 8 - tf file</summary>

```tf
provider "github" {
  token = var.github_key
}

```
</details>
<details><summary>Negative test num. 9 - tf file</summary>

```tf
provider "cloudflare" {
  version = "~> 2.0"
  email   = "var.cloudflare_email"
  api_key = "var.api_key"
}

```
</details>
<details><summary>Negative test num. 10 - yaml file</summary>

```yaml
Parameters:
  PrivateKey1:
    Type: String
Resources:
  PinpointApp:
    Type: AWS::Pinpoint::App
    Properties:
      Name: foobar
  PinpointAPNSChannel:
    Type: AWS::Pinpoint::APNSChannel
    Properties:
      PrivateKey: !GetAtt PrivateKey1

```
</details>
<details><summary>Negative test num. 11 - yaml file</summary>

```yaml
Parameters:
  PinpointAPNSVoipChannelTokenKey:
    Type: String
Resources:
  ElastiCacheReplicationGroup:
    Type: AWS::ElastiCache::ReplicationGroup
    Properties:
      AuthToken: !Ref PinpointAPNSVoipChannelTokenKey
      CacheNodeType: cache.m5.large
      CacheSubnetGroupName: subnet-foobar
      Engine: redis
      EngineVersion: '5.0.0'
      NumCacheClusters: 2
      ReplicationGroupDescription: foobar
      SecurityGroupIds:
        - sg-foobar
      TransitEncryptionEnabled: True
  PinpointApp:
    Type: AWS::Pinpoint::App
    Properties:
      Name: foobar
  PinpointAPNSChannel:
    Type: AWS::Pinpoint::APNSChannel
    Properties:
      TokenKey: !Ref PinpointAPNSVoipChannelTokenKey
      ApplicationId: !Ref PinpointApp

```
</details>
<details><summary>Negative test num. 12 - yaml file</summary>

```yaml
#cloud formation test
Resources:
  RDSCluster:
    Type: "AWS::RDS::DBCluster"
    Properties:
      MasterUserPassword: !Ref PasswordMaster
      DBClusterIdentifier: my-serverless-cluster
      Engine: aurora
      EngineVersion: 5.6.10a
      EngineMode: serverless
      ScalingConfiguration:
        AutoPause: true
        MinCapacity: 4
        MaxCapacity: 32
        SecondsUntilAutoPause: 1000

```
</details>
<details><summary>Negative test num. 13 - yaml file</summary>

```yaml
- name: Start a workflow in the Itential Automation Platform
  community.network.iap_start_workflow:
    iap_port: 3000
    iap_fqdn: localhost
    workflow_name: "RouterUpgradeWorkflow"
    description: "OS-Router-Upgrade"
    variables: {"deviceName":"ASR9K"}
  register: result

```
</details>
<details><summary>Negative test num. 14 - tf file</summary>

```tf
provider "mailgun" {
  api_key = "var.mailgun_api_key"
}

```
</details>
<details><summary>Negative test num. 15 - tf file</summary>

```tf
provider "stripe" {
  api_key = var.strip_restricted_api_key
}

```
</details>
<details><summary>Negative test num. 16 - yaml file</summary>

```yaml
- hosts: all
  remote_user: root
  vars:
    twilio_api_key: '{{ TWILIO_API_KEY }}'

```
</details>
<details><summary>Negative test num. 17 - yaml file</summary>

```yaml
- hosts: all
  remote_user: root
  vars:
    paypal_access_token: '{{ PAYPAL_ACCESS_TOKEN }}'


```
</details>
<details><summary>Negative test num. 18 - yaml file</summary>

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: envar-demo
  labels:
    purpose: demonstrate-envars
spec:
  containers:
  - name: envar-demo-container
    image: gcr.io/google-samples/node-hello:1.0

```
</details>
<details><summary>Negative test num. 19 - yaml file</summary>

```yaml
apiVersion: v1
kind: Config
users:
- name: cluster-admin
  user:
    auth-provider:
      config: {}
      name: gcp
- name: google-oauth-access-token
  user:
    auth-provider:
      config:
        access-token: '{.credential.oauth_access_token_}'
        cmd-args: config config-helper --format=json
        cmd-path: /Users/dave/google-cloud-sdk/bin/gcloud
        expiry: 2021-10-28T15:12:03.000Z
        expiry-key: '{.credential.token_expiry}'
        token-key: '{.credential.access_token}'
      name: gcp

```
</details>
<details><summary>Negative test num. 20 - tf file</summary>

```tf
resource "aws_lambda_function" "analysis_lambda4" {
  # lambda have plain text secrets in environment variables
  filename      = "resources/lambda_function_payload.zip"
  function_name = "${local.resource_prefix.value}-analysis"
  role          = "aws_iam_role.iam_for_lambda.arn"
  handler       = "exports.test"

  source_code_hash = "${filebase64sha256("resources/lambda_function_payload.zip")}"

  runtime = "nodejs12.x"
}

```
</details>
<details><summary>Negative test num. 21 - tf file</summary>

```tf
provider rancher2 {
  api_url   = data.terraform_remote_state.rancher.outputs.api_url
  token_key = data.terraform_remote_state.rancher.outputs.token_key
}

```
</details>
<details><summary>Negative test num. 22 - yaml file</summary>

```yaml
name: Example Workflow

on: workflow_call

jobs:
  build-deploy:
    permissions:
      contents: read
      pages: write
      id-token: write

    runs-on: ubuntu

    steps:
      - uses: actions/checkout@v4

---

name: Example Workflow

on: workflow_call

jobs:
  build-deploy:
    permissions:
      contents: read
      pages: write
      id-token: read

    runs-on: ubuntu

    steps:
      - uses: actions/checkout@v4

---

name: Example Workflow

on: workflow_call

jobs:
  build-deploy:
    permissions:
      contents: read
      pages: write
      id-token: none

    runs-on: ubuntu

    steps:
      - uses: actions/checkout@v4

```
</details>
<details><summary>Negative test num. 23 - yaml file</summary>

```yaml
#ansible test
- name: create a cluster
  google.cloud.gcp_container_cluster:
    name: my-cluster
    initial_node_count: 2
    node_config:
      machine_type: n1-standard-4
      disk_size_gb: 500
    location: us-central1-a
    project: test_project
    auth_kind: serviceaccount
    service_account_file: "/tmp/auth.pem"
    state: present

```
</details>
<details><summary>Negative test num. 24 - yaml file</summary>

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  automountServiceAccountToken: false
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
  volumes:
    - name: sec-ctx-vol
      emptyDir: { }
  containers:
    - name: sec-ctx-demo
      image: busybox
      command: [ "sh", "-c", "sleep 1h" ]
      volumeMounts:
        - name: sec-ctx-vol
          mountPath: /data/demo
      securityContext:
        allowPrivilegeEscalation: false
```
</details>
<details><summary>Negative test num. 25 - yaml file</summary>

```yaml
- name: 'aws_codebuild integration tests'
  collections:
    - amazon.aws
  module_defaults:
    group/aws:
      aws_access_key: '{{ aws_access_key }}'
      aws_secret_key: '{{ aws_secret_key }}'
      security_token: '{{ security_token | default(omit) }}'
      region: '{{ aws_region }}'
  block:
    - name: idempotence check rerunning same Codebuild task
      aws_codebuild:
        name: "{{ resource_prefix }}-test-ansible-codebuild"
        description: Build project for testing the Ansible aws_codebuild module
        service_role: "{{ codebuild_iam_role.iam_role.arn }}"
        timeout_in_minutes: 30
        source:
          type: CODEPIPELINE
          buildspec: ''
        artifacts:
          namespace_type: NONE
          packaging: NONE
          type: CODEPIPELINE
          name: test
        encryption_key: 'arn:aws:kms:{{ aws_region }}:{{ aws_account_id }}:alias/aws/s3'
        environment:
          compute_type: BUILD_GENERAL1_SMALL
          privileged_mode: true
          image: 'aws/codebuild/docker:17.09.0'
          type: LINUX_CONTAINER
          environment_variables:
            - { name: 'FOO_ENV', value: 'other' }
        tags:
          - { key: 'purpose', value: 'ansible-test' }
        state: present
      register: rerun_test_output

```
</details>
<details><summary>Negative test num. 26 - yaml file</summary>

```yaml
Conditions:
  HasKmsKey: !Not [!Equals [!Ref ParentKmsKeyStack, '']]
  HasSecretName: !Not [!Equals [!Ref ParentKmsKeyStack, '']]
  HasPassword: !Not [!Equals [!Ref DBPassword, '']]
Resources:
```
</details>
<details><summary>Negative test num. 27 - yaml file</summary>

```yaml
Resources:
  LambdaFunctionV2:
    Type: 'AWS::Lambda::Function'
    Properties:
      Code:
        ZipFile: |
          'use strict';
          const AWS = require('aws-sdk');
          const response = require('cfn-response');
          const iam = new AWS.IAM({apiVersion: '2010-05-08'});
          exports.handler = (event, context, cb) => {
            console.log(`Invoke: ${JSON.stringify(event)}`);
            function done(err) {
              if (err) {
                console.log(`Error: ${JSON.stringify(err)}`);
                response.send(event, context, response.FAILED, {});
              } else {
                response.send(event, context, response.SUCCESS, {});
              }
            }
            if (event.RequestType === 'Delete') {
              iam.deleteAccountPasswordPolicy({}, done);
            } else if (event.RequestType === 'Create' || event.RequestType === 'Update') {
              const params = {
                MinimumPasswordLength: parseInt(event.ResourceProperties.MinimumPasswordLength, 10),
                RequireSymbols: event.ResourceProperties.RequireSymbols === 'true',
                RequireNumbers: event.ResourceProperties.RequireNumbers === 'true',
                RequireUppercaseCharacters: event.ResourceProperties.RequireUppercaseCharacters === 'true',
                RequireLowercaseCharacters: event.ResourceProperties.RequireLowercaseCharacters === 'true',
                AllowUsersToChangePassword: event.ResourceProperties.AllowUsersToChangePassword === 'true',
                HardExpiry: event.ResourceProperties.HardExpiry === 'true'
              };
              if (parseInt(event.ResourceProperties.MaxPasswordAge, 10) > 0) {
                params.MaxPasswordAge = parseInt(event.ResourceProperties.MaxPasswordAge, 10);
              }
              if (parseInt(event.ResourceProperties.PasswordReusePrevention, 10) > 0) {
                params.PasswordReusePrevention = parseInt(event.ResourceProperties.PasswordReusePrevention, 10);
              }
              iam.updateAccountPasswordPolicy(params, done);
            } else {
              cb(new Error(`unsupported RequestType: ${event.RequestType}`));
            }
          };
      Handler: 'index.handler'
      MemorySize: 128
      Role: !GetAtt 'LambdaRole.Arn'
      Runtime: 'nodejs12.x'
      Timeout: 60

```
</details>
<details><summary>Negative test num. 28 - tf file</summary>

```tf
locals {
  secrets = {
    my_secret = random_password.my_password.result
  }
}

```
</details>
<details><summary>Negative test num. 29 - dockerfile file</summary>

```dockerfile
FROM baseImage

RUN apk add --no-cache git \
    && git config \
    --global \
    url."https://${GIT_USER}:${GIT_TOKEN}@github.com".insteadOf \
    "https://github.com"


```
</details>
<details><summary>Negative test num. 30 - tf file</summary>

```tf
resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  connection {
    user        = "ubuntu"
    private_key = file(var.private_key_path)
  }
}

```
</details>
<details><summary>Negative test num. 31 - yaml file</summary>

```yaml
Resources:
  MytFunction:
    Type: AWS::Lambda::Function
    Properties:
      FunctionName: !Sub '${AWS::StackName}-CdnViewerRequest'
      Code:
        ZipFile: !Sub |
          function msg(userPass) {
            return {"username": userPass[1], "password": userPass[2]}
          }

```
</details>
<details><summary>Negative test num. 32 - yaml file</summary>

```yaml
Type: AWS::Glue::Connection
Resources:
  Properties:
    CatalogId: "1111111111111"
    ConnectionInput:
      ConnectionProperties:
          CONNECTION_URL:
            Fn::Join:
              - ""
              - - "mongodb://{{resolve:secretsmanager:arn:"
                - Ref: AWS::Partition
                - :secretsmanager:eu-west-1:1111111111111:secret:/test/resources/docdb-test:SecretString:endpoint::}}/test
          USERNAME:
            Fn::Join:
              - ""
              - - "{{resolve:secretsmanager:arn:"
                - Ref: AWS::Partition
                - :secretsmanager:eu-west-1:1111111111111:secret:/test/resources/docdb-test:SecretString:username::}}
          PASSWORD:
            Fn::Join:
              - ""
              - - "{{resolve:secretsmanager:arn:"
                - Ref: AWS::Partition
                - :secretsmanager:eu-west-1:1111111111111:secret:/test/resources/docdb-test:SecretString:password::}}
          JDBC_ENFORCE_SSL: true
      ConnectionType: MONGODB

```
</details>
<details><summary>Negative test num. 33 - yaml file</summary>

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Resources:
  somecode:
    Type: AWS::CodeBuild::Project
    Properties:
      Name: somecodename
      Description: somecodedesc
      TimeoutInMinutes: 10
      QueuedTimeoutInMinutes: 10
      ServiceRole: someservicerole
      EncryptionKey: somekey
      Artifacts:
        Type: someartifact
      Cache:
        Type: somecache
        Modes:
          - mode1
          - mode2
      Environment:
        ComputeType: somecomputetype
        Image: someimage
        Type: someenv
        ImagePullCredentialsType: somepulltype
      Source:
        Type: somesource
        Location: somelocation
        GitCloneDepth: 1

```
</details>
<details><summary>Negative test num. 34 - tf file</summary>

```tf
#this code is a correct code for which the query should not find any result
resource "google_container_cluster" "primary" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_secret_manager_secret_version" "secret-version-basic" {
  secret = var.my_google_secret

  secret_data = "secret-data"
}

```
</details>
<details><summary>Negative test num. 35 - yaml file</summary>

```yaml
Type: AWS::Glue::Connection
Resources:
  Properties:
    CatalogId: "1111111111111"
    ConnectionInput:
      ConnectionProperties:
          CONNECTION_URL:
            Fn::Join:
              - ""
              - - "mongodb://{{resolve:secretsmanager:arn:"
                - Ref: AWS::Partition
                - :secretsmanager:*:1111111111111:secret:/test/resources/docdb-test:SecretString:endpoint::}}/test
          USERNAME:
            Fn::Join:
              - ""
              - - "{{resolve:secretsmanager:arn:"
                - Ref: AWS::Partition
                - :secretsmanager:eu-west-1:*:secret:/test/resources/docdb-test:SecretString:username::}}
          PASSWORD:
            Fn::Join:
              - ""
              - - "{{resolve:secretsmanager:arn:"
                - Ref: AWS::Partition
                - :secretsmanager:us-east-?:*:secret:tiny::}}
          JDBC_ENFORCE_SSL: true
      ConnectionType: MONGODB

```
</details>
<details><summary>Negative test num. 36 - yaml file</summary>

```yaml
---
AWSTemplateFormatVersion: "2010-09-09"
Description: >
  Test values for GetAtt and Ref and conditions
Parameters:
  pSubnets:
    Type: List<String>
    Default: ''
  pSubnet:
    Type: String
    Default: ''
  pSsmSubnets:
    Type: AWS::SSM::Parameter::Value<List<AWS::EC2::Subnet::Id>>
    Default: ''
Conditions:
  cCreateSubnets: !Not [!Equals [!Ref pSubnets, '']]
  cNotCreateSubnets: !Not [!Condition cCreateSubnets]
  cUseSsmSubnets: !And [!Condition cNotCreateSubnets, !Not [!Equals [pSsmSubnets, '']]]
Resources:
  Subnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: 'vpc-1234567'
      CidrBlock: 10.0.0.0/24
  Subnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: 'vpc-1234567'
      CidrBlock: 10.0.0.2/24
  LoadBalancer:
    Type: AWS::ElasticLoadBalancing::LoadBalancer
    Properties:
      Listeners:
      -
        InstancePort: '80'
        LoadBalancerPort: '80'
        Protocol: HTTP
      Subnets:
        Fn::If:
        - cCreateSubnets
        - - !Ref Subnet1
          - !Ref Subnet2
          - !Ref pSubnet  # extra check to validate singular parameter works
        - Fn::If:
          - cUseSsmSubnets
          - !Ref pSsmSubnets
          - !Ref pSubnets
  LoadBalancer2:
    Type: AWS::ElasticLoadBalancing::LoadBalancer
    Properties:
      Fn::If:
      - cCreateSubnets
      - Listeners:
        -
          InstancePort: '80'
          LoadBalancerPort: '80'
          Protocol: HTTP
        Subnets:
          - !Ref Subnet1
          - !Ref Subnet2
      - Fn::If:
        - cUseSsmSubnets
        - Listeners:
          -
            InstancePort: '80'
            LoadBalancerPort: '80'
            Protocol: HTTP
          Subnets: !Ref pSsmSubnets
        - Listeners:
          -
            InstancePort: '80'
            LoadBalancerPort: '80'
            Protocol: HTTP
          Subnets: !Ref pSubnets
  ### Test Custom Resources Don't fail
  GetSubnets:
    Type: AWS::CloudFormation::CustomResource
    Properties:
      ServiceToken: anArn
  LoadBalancer3:
    Type: AWS::ElasticLoadBalancing::LoadBalancer
    Properties:
      Listeners:
      -
        InstancePort: '80'
        LoadBalancerPort: '80'
        Protocol: HTTP
      Subnets: !GetAtt GetSubnets.Subnets
  ### Test getatt to another resource and a list getatt
  SecurityGroup1:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: LoadBalancer Security Group
  alb1:
    Type: AWS::ElasticLoadBalancingV2::LoadBalancer
    Properties:
      Scheme: internal
      Subnets: !Ref pSubnets
      LoadBalancerAttributes:
      - Key: idle_timeout.timeout_seconds
        Value: '50'
      SecurityGroups:
      - Ref: SecurityGroup1
  alb2:
    Type: AWS::ElasticLoadBalancingV2::LoadBalancer
    Properties:
      Scheme: internal
      Subnets: !Ref pSubnets
      LoadBalancerAttributes:
      - Key: idle_timeout.timeout_seconds
        Value: '50'
      SecurityGroups: !GetAtt alb1.SecurityGroups
  ### Test CloudFormation resource for Get Atts
  SubStack:
    Type: AWS::CloudFormation::Stack
    Properties:
      TemplateURL: https://example.com
  albCfn2:
    Type: AWS::ElasticLoadBalancingV2::LoadBalancer
    Properties:
      Scheme: internal
      Subnets: !Ref pSubnets
      LoadBalancerAttributes:
      - Key: idle_timeout.timeout_seconds
        Value: '50'
      SecurityGroups:
      - !GetAtt SubStack.Outputs.SecurityGroups
  Listener:
    Type: AWS::ElasticLoadBalancingV2::Listener
    Properties:
      Protocol:
        Fn::GetAtt:
        - SubStack
        - Outputs.Protocol
      LoadBalancerArn: !GetAtt SubStack.Outputs.LoadBalancerArn
  KinesisStream:
    Type: AWS::Kinesis::Stream
    Properties:
      ShardCount: 1
  StreamConsumer:
    Type: AWS::Kinesis::StreamConsumer
    Properties:
      ConsumerName: MyConsumer
      StreamARN: !GetAtt KinesisStream.Arn
  03EventSourceMapping:
    Type: AWS::Lambda::EventSourceMapping
    Properties:
      BatchSize: 500
      Enabled: true
      EventSourceArn: !GetAtt StreamConsumer.ConsumerARN
      FunctionName: !Ref LambdaFunctionArn
      StartingPosition: LATEST
  04EventSourceMapping:
    Type: AWS::Lambda::EventSourceMapping
    Properties:
      BatchSize: 500
      Enabled: true
      EventSourceArn: !GetAtt StreamConsumer.StreamARN
      FunctionName: !Ref LambdaFunctionArn
      StartingPosition: LATEST

```
</details>
<details><summary>Negative test num. 37 - tf file</summary>

```tf
data "terraform_remote_state" "intnet" {
  backend = "azurerm"
  config = {
    storage_account_name = "asdsadas"
    container_name       = "dp-prasdasdase-001"
    key                  = "infrastructure.tfstate"
    access_key           = file(var.access_key_path)
  }
  workspace = terraform.workspace
}

```
</details>
<details><summary>Negative test num. 38 - tf file</summary>

```tf
#this is a problematic code where the query should report a result(s)
resource "google_container_cluster" "primary1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = local.rds_postgres_is_primary ? var.rds_postgres_password : null

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

```
</details>
<details><summary>Negative test num. 39 - yml file</summary>

```yml
on: workflow_call

stages:
  - build

variables:
  GIT_PRIVATE_KEY: $GIT_PRIVATE_KEY

jobs:
  job_build:
    stage: build
    script:
      - if [[ -z "${GIT_PRIVATE_KEY:-}" ]]; then
          echo "Missing GIT_PRIVATE_KEY variable!"
          exit 1
        fi
      - echo "Private key is set."

    steps:
      - uses: actions/checkout@v4
```
</details>
<details><summary>Negative test num. 40 - yml file</summary>

```yml
- name: "Configure the MySQL user "
  community.mysql.mysql_user:
    login_user: "root"
    login_password: "{{ mysql_root_password }}"
    name: "{{ mysql_user }}"
    password: "{{ mysql_user_password }}"
    password_expire: "never"
    update_password: "on_create"

```
</details>
<details><summary>Negative test num. 41 - yaml file</summary>

```yaml
name: Deploy
on:
  workflow_call:
    inputs:
      environment:
        description: Github environment
        required: false
        type: string
      githubRunner:
        description: github runner lables
        type: string
        required: false
      helmInstall:
        description: install the helm release
        type: string
        required: false
        default: true
jobs:
  push_deploy:
    environment: ${{ inputs.environment }}
    runs-on: ${{ fromJSON(inputs.githubRunner) }}
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-tags: true
          fetch-depth: 0
      - name: Get secrets from Azure Key Vault
        run: |
          set -e
          vault_name="${{ vars.AZURE_KV }}"
          auth0_client_id=$(az keyvault secret show --vault-name $vault_name --name cel-auth0-client-id --query "value" -o tsv)
          auth0_client_secret=$(az keyvault secret show --vault-name $vault_name --name cel-auth0-client-secret --query "value" -o tsv)
          restapi_mgt_appid=$(az keyvault secret show --vault-name $vault_name --name cel-restapi-mgt-appid --query "value" -o tsv)
          restapi_mgt_appsec=$(az keyvault secret show --vault-name $vault_name --name cel-restapi-mgt-appsec --query "value" -o tsv)
          cel_projectmgr_db_user=$(az keyvault secret show --vault-name $vault_name --name cel-projectmgr-db-user --query "value" -o tsv)
          cel_projectmgr_db_password=$(az keyvault secret show --vault-name $vault_name --name cel-projectmgr-db-password --query "value" -o tsv)
          cel_project_export_key=$(az keyvault secret show --vault-name $vault_name --name cel-project-export-key --query "value" -o tsv)
          # This escapes the commas in the vars.AUTH0_CNX_LIST env. variable by adding a backslash in front of it
          auth0_cnx_list=$(echo ${{ vars.AUTH0_CNX_LIST }} | sed 's/,/\\,/')
          # Mask secrets
          echo "::add-mask::$auth0_client_id"
          echo "::add-mask::$auth0_client_secret"
          echo "::add-mask::$restapi_mgt_appid"
          echo "::add-mask::$restapi_mgt_appsec"
          echo "::add-mask::$cel_projectmgr_db_user"
          echo "::add-mask::$cel_projectmgr_db_password"
          echo "::add-mask::$cel_project_export_key"
          echo "AUTH0_CLIENT_ID=$auth0_client_id" >> $GITHUB_ENV
          echo "AUTH0_CLIENT_SECRET=$auth0_client_secret" >> $GITHUB_ENV
          echo "RESTAPI_MGT_APPID=$restapi_mgt_appid" >> $GITHUB_ENV
          echo "RESTAPI_MGT_APPSEC=$restapi_mgt_appsec" >> $GITHUB_ENV
          echo "CEL_PROJECTMGR_DB_USER=$cel_projectmgr_db_user" >> $GITHUB_ENV
          echo "CEL_PROJECTMGR_DB_PASSWORD=$cel_projectmgr_db_password" >> $GITHUB_ENV
          echo "CEL_PROJECT_EXPORT_KEY=$cel_project_export_key" >> $GITHUB_ENV
          echo "AUTH0_CNX_LIST=$auth0_cnx_list" >> $GITHUB_ENV
      - name: Get EA secrets from Azure Key Vault
        if: ${{ inputs.environment == 'ea' }}
        run: |
          set -e
          vault_name="${{ vars.AZURE_KV }}"
          auth0_client_id=$(az keyvault secret show --vault-name $vault_name --name cel-auth0-client-id-${{ inputs.environment }} --query value -o tsv)
          auth0_client_secret=$(az keyvault secret show --vault-name $vault_name --name cel-auth0-client-secret-${{ inputs.environment }} --query value -o tsv)
          restapi_mgt_appid=$(az keyvault secret show --vault-name $vault_name --name cel-restapi-mgt-appid-${{ inputs.environment }} --query value -o tsv)
          restapi_mgt_appsec=$(az keyvault secret show --vault-name $vault_name --name cel-restapi-mgt-appsec-${{ inputs.environment }} --query value -o tsv)
          # Mask secrets
          echo "::add-mask::$auth0_client_id"
          echo "::add-mask::$auth0_client_secret"
          echo "::add-mask::$restapi_mgt_appid"
          echo "::add-mask::$restapi_mgt_appsec"
          echo "AUTH0_CLIENT_ID=${auth0_client_id}" >> $GITHUB_ENV
          echo "AUTH0_CLIENT_SECRET=${auth0_client_secret}" >> $GITHUB_ENV
          echo "RESTAPI_MGT_APPID=${restapi_mgt_appid}" >> $GITHUB_ENV
          echo "RESTAPI_MGT_APPSEC=${restapi_mgt_appsec}" >> $GITHUB_ENV
```
</details>
<details><summary>Negative test num. 42 - tf file</summary>

```tf
provider "azurerm" {
  features {}
}

# Example of using an existing Key Vault and secret
data "azurerm_key_vault" "example" {
  name                = "your-key-vault-name"
  resource_group_name = "your-resource-group"
}

data "azurerm_key_vault_secret" "LinuxVmPassword" {
  name          = "your-secret-name"
  key_vault_id  = data.azurerm_key_vault.example.id
}

resource "azurerm_linux_virtual_machine" "example_vm" {
  name                = "example-vm"
  resource_group_name = "your-resource-group"
  location            = "your-location"
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = data.azurerm_key_vault_secret.LinuxVmPassword.value

  network_interface_ids = [
    # Your network interface ID
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

output "vm_password" {
  value     = data.azurerm_key_vault_secret.LinuxVmPassword.value
  sensitive = true
}

```
</details>
<details><summary>Negative test num. 43 - tf file</summary>

```tf
data "template_file" "sci_integration_app_properties_secret_template" {
  template = file(join("", ["/secrets/sci-integration-app", var.resource_identifier_shorthand], ".json"))

  vars = {
    ayreshirerarran_password   = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["ayreshirerarran_password"]
    lanark_password            = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["lanark_password"]
    tayside_password           = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["tayside_password"]
    glasgow_password           = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["glasgow_password"]
    grampian_password          = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["grampian_password"]
    highland_password          = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["highland_password"]
    westernisles_password      = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["westernisles_password"]
    dumfriesandgalloway_password = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["dumfriesandgalloway_password"]
    forthvalley_password       = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["forthvalley_password"]
    borders_password           = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["borders_password"]
    lothian_password           = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["lothian_password"]
  }
}

```
</details>
<details><summary>Negative test num. 44 - dockerfile file</summary>

```dockerfile
FROM baseImage

ENV ARTEMIS_USER artemis

RUN apk add --no-cache git \
    && git config \
    --global \
    url."https://${GIT_USER}:${GIT_TOKEN}@github.com".insteadOf \
    "https://github.com"


```
</details>
<details><summary>Negative test num. 45 - dockerfile file</summary>

```dockerfile
FROM baseImage

RUN command

```
</details>
<details><summary>Negative test num. 46 - dockerfile file</summary>

```dockerfile
FROM baseImage

ENV ARTEMIS_USER=artemis

RUN apk add --no-cache git \
    && git config \
    --global \
    url."https://${GIT_USER}:${GIT_TOKEN}@github.com".insteadOf \
    "https://github.com"


```
</details>
<details><summary>Negative test num. 47 - yml file</summary>

```yml
stages:
- template: templates/main-stage.yml
  parameters:
    environment:                      'foo'
    isSm9ChangeRequired:              true
  
    isDedicatedSubscription:          'true'
    setResourceLock:                  'true'
    nameResourceLock:                 'PrdPreventAccidentalDeletion'
    isDevelopment:                    'false'
    # example 1 (placeholders)
    vmAdminPassword:                  '$(VM_ADMIN_PASSWORD)'                 # SET IN PIPELINE
    sqlAdminPassword:                 '$(SQL_ADMIN_PASSWORD)'                # SET IN PIPELINE
    yetanotherAdminPassword:          '${{SQL_ADMIN_PASSWORD}}'                # SET IN PIPELINE
    andyetanotherAdminPassword:       '${{ SQL_ADMIN_PASSWORD }}'                # SET IN PIPELINE

    # example 2 (empty string value)
    anotherAdminPassword:             ''                 # SET IN PIPELINE

    serviceConnectionName:            'foo' 
    subscriptionId:                   'foo'
    organisationalGroup:              'foo'        # Replace this with your own Organisational Group name.
    devOrganisationalGroup:           'foo'                                     # should be empty for none DEV env
    sm9ApplicationCi:                 'foo'                                  # Replace this with your own SM9 Application CI name.
    resourceGroupBaseName:            'foo'                 # This is used to construct a Resource Group name. Replace this with your desired resource group name.
    resourceGroupNameSuffix:          'foo'                                    # This is suffixed to the Resource Group name in a Shared subscription (must be an integer). Can be left as-is.
    location:                         'foo'                           # Replace this with your desired Azure region.
    linuxAgentPoolName:               'foo'                # Agent pool name of Linux agents. Can be left as-is.
    windowsAgentPoolName:             'foo'              # Agent pool name of Windows agents. Can be left as-is.
    System.Debug:                     'foo'                                 # Set to 'foo' to enable debug logging. Can be left as-is.

    skipAdditionalResources:          'foo'                                # if true skip creating additional resources
    skipSQL:                          'foo'

    #####################################################################################
    # ADF                                                                               #
    #####################################################################################
    adfName:                          'foo'
    adfDeveloperGroup:                'foo'        # Group has access to ADF
    irName:                           'foo'
    irDescription:                    'foo'



```
</details>
<details><summary>Negative test num. 48 - yml file</summary>

```yml
version: '3.7'

services:
  apis:
    image: ""
    env_file:
      - .env
    environment:
      env: "dev"

      # this value is a Docker Compose secrets path, its contents are not exposed
      PrivateKey: /run/secrets/SOME_AUTHORIZATION_PRIVATE_KEY

secrets:
  SOME_AUTHORIZATION_PRIVATE_KEY:
    external: true


```
</details>
<details><summary>Negative test num. 49 - json file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "siteName": {
      "type": "string"
    },
    "administratorLogin": {
      "type": "string"
    },
    "administratorLoginPassword": {
      "type": "securestring"
    },
    "secretSuffix": {
      "type": "string",
      "defaultValue": "word"
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]"
    }
  },
  "variables": {
    "databaseName": "[concat(parameters('siteName'), 'db')]",
    "serverName": "[concat(parameters('siteName'), 'srv')]",
    "hostingPlanName": "[concat(parameters('siteName'), 'plan')]",
    "passKey": "[concat('Pass', parameters('secretSuffix'))]"
  },
  "resources": [
    {
      "apiVersion": "2020-06-01",
      "type": "Microsoft.Web/serverfarms",
      "name": "[variables('hostingPlanName')]",
      "location": "[parameters('location')]",
      "sku": {
        "Tier": "Standard",
        "Name": "S1"
      },
      "properties": {}
    },
    {
      "apiVersion": "2020-06-01",
      "type": "Microsoft.Web/sites",
      "name": "[parameters('siteName')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Web/serverfarms', variables('hostingPlanName'))]"
      ],
      "properties": {
        "serverFarmId": "[variables('hostingPlanName')]"
      },
      "resources": [
        {
          "apiVersion": "2020-06-01",
          "type": "config",
          "name": "connectionstrings",
          "properties": {
            "defaultConnection": {
              "value": "[concat('Database=', variables('databaseName'), ';Data Source=', reference(resourceId('Microsoft.DBforMySQL/servers',variables('serverName'))).fullyQualifiedDomainName, ';User Id=', parameters('administratorLogin'),'@', variables('serverName'),';Password=', parameters('administratorLoginPassword'))]",
              "type": "MySql"
            }
          }
        }
      ]
    }
  ]
}
```
</details>
<details><summary>Negative test num. 50 - yml file</summary>

```yml
jobs:
  release:
    if: github.event.pull_request.merged == true || github.event_name == 'push' || github.event_name == 'workflow_dispatch'
    runs-on:
      group: Prod
      labels: helm
    permissions:
       contents: write # for publishing release
       actions: write # for createWorkflowDispatch
       issues: write # for comments on issues
       pull-requests: write # for comments on pull requests
       #id-token: write # for oidc npm provenance
       #"id-token": read 
       #'id-token': none
       #permissions: {id-token: write, contents: read, pull-requests: write} 
    steps:
      - name: debug
        shell: bash
        run: |
          echo 'github.event_actor=${{ github.event_actor }}'
```
</details>
<details><summary>Negative test num. 51 - json file</summary>

```json
{
  "openapi": "3.0.0",
  "info": {
    "title": "Simple API Overview",
    "version": "1.0.0"
  },
  "paths": {},
  "servers": [
    {
      "url": "https://my.api.server.com/",
      "description": "My API Server 1"
    }
  ]
}

```
</details>
<details><summary>Negative test num. 52 - tf file</summary>

```tf
resource "google_container_cluster" "primary3" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = "1234567890qwertyuiopasdfghjklçzxcvbnm"
    password = ""

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

```
</details>
<details><summary>Negative test num. 53 - tf file</summary>

```tf
resource "google_container_cluster" "primary5" {
  name               = "marcellus-wallace-credential"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = "PRIVATE KEY_key"
    password = ""

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

```
</details>
<details><summary>Negative test num. 54 - tf file</summary>

```tf
resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "secret-version"

  labels = {
    label = "my-label"
  }

  replication {
    automatic = true
  }
}

```
</details>
