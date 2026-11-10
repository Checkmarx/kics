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
-   **Risk score:** <span style="color:#bb2124">7.8</span>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/common/passwords_and_secrets)

### Description
Query to find passwords and secrets in infrastructure code.<br>
[Documentation](https://docs.kics.io/latest/secrets/)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="8"
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test (k8s)
apiVersion: v1
kind: Secret
metadata:
  name: secret-basic-auth
type: kubernetes.io/basic-auth
stringData:
  password: "root"  # positive1

```
```json title="Positive test num. 2 - json file" hl_lines="10 20 30"
{
  "metadata1": "'Password in URL' - c4d3b58a-e6d4-450f-9340-04f1e702eaae  positive-test (line 10)",
  "metadata2": "'Slack Webhook'   - ccde326f-ebc7-4772-8ad5-de66e90a8cc3  positive-test (line 20)",
  "metadata3": "'MSTeams Webhook' - d6214dca-a31b-425f-bcf7-f4faa772a1c0  positive-test (line 30)",
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
```yaml title="Positive test num. 3 - yaml file" hl_lines="10 12 14"
# "Password in URL" - c4d3b58a-e6d4-450f-9340-04f1e702eaae  positive-test - #1
# "Slack Webhook"   - ccde326f-ebc7-4772-8ad5-de66e90a8cc3  positive-test - #2
# "MSTeams Webhook" - d6214dca-a31b-425f-bcf7-f4faa772a1c0  positive-test - #3
openapi: 3.0.0
info:
  title: Simple API Overview
  version: 1.0.0
paths: {}
servers:
  - url: http://bob:sekret@example.invalid/some/path  #1
    description: My API Server 1
  - url: https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX  #2
    description: My API Server 2
  - url: https://team_name.webhook.office.com/webhookb2/7aa49aa6-7840-443d-806c-08ebe8f59966@c662313f-14fc-43a2-9a7a-d2e27f4f3478/IncomingWebhook/8592f62b50cf41b9b93ba0c0a00a0b88/eff4cd58-1bb8-4899-94de-795f656b4a18 #3
    description: My API Server 3


```
<details><summary>Positive test num. 4 - json file</summary>

```json hl_lines="19 12 23 15"
{
  "metadata1": "'Generic Password' - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test (line 12)",
  "metadata2": "'Password in URL'  - c4d3b58a-e6d4-450f-9340-04f1e702eaae  positive-test (line 15)",
  "metadata3": "'Slack Webhook'    - ccde326f-ebc7-4772-8ad5-de66e90a8cc3  positive-test (line 19)",
  "metadata4": "'MSTeams Webhook'  - d6214dca-a31b-425f-bcf7-f4faa772a1c0  positive-test (line 23)",
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

```tf hl_lines="7"
# "Asymmetric private key" - 51b5b840-cd0c-4556-98a7-fe5f4def80cf  positive-test (line 7)
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

```tf hl_lines="18 19"
# "AWS Access Key" - 76c0bcde-903d-456e-ac13-e58c34987852  positive-test (line 18)
# "AWS Secret Key" - 83ab47ff-381d-48cd-bac5-fb32222f54af  positive-test (line 19)
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

```tf hl_lines="16 17"
# "AWS Access Key" - 76c0bcde-903d-456e-ac13-e58c34987852  positive-test (line 16)
# "AWS Secret Key" - 83ab47ff-381d-48cd-bac5-fb32222f54af  positive-test (line 17)
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

```
</details>
<details><summary>Positive test num. 8 - yaml file</summary>

```yaml hl_lines="35 37"
# "K8s Environment Variable Password" - 4b2b5fd3-364d-4093-bac2-17391b2a5297  positive-test
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
              value: "passx"          # positive1
            - name: DB_PASS_BD_2
              value: "passx"          # positive2
            - name: DB_USER_BD
              value: "userx"

```
</details>
<details><summary>Positive test num. 9 - tf file</summary>

```tf hl_lines="8"
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test
resource "azurerm_sql_server" "example" {
  name                         = "kics-test"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "ariel"
  administrator_login_password = "Aa12345678" # positive1

  tags = {
    environment = var.environment
    terragoat   = "true"
  }
}

```
</details>
<details><summary>Positive test num. 10 - tf file</summary>

```tf hl_lines="6"
# "Google OAuth" - d651cca2-2156-4d17-8e76-423e68de5c8b  positive-test
resource "auth0_connection" "google_oauth2" {
  name = "Google-OAuth2-Connection"
  strategy = "google-oauth2"
  options {
    client_id = "53221331-2323wasdfa343rwhthfaf33feaf2fa7f.apps.googleusercontent.com"  # positive1
    client_secret = "j2323232324"
    allowed_audiences = [ "example.com", "api.example.com" ]
    scopes = [ "email", "profile", "gmail", "youtube" ]
    set_user_root_attributes = "on_each_login"
  }
}

```
</details>
<details><summary>Positive test num. 11 - tf file</summary>

```tf hl_lines="4"
# "Slack Token"   - 7908a9e3-5cac-41b1-b514-5f6d82ce02d5                           positive-test
# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding Slack Token"  allow-rule-test
provider "slack" {
  token = "xoxp-121314151623-121314151623-121314151623-12131423121314151623121314151623"
}

```
</details>
<details><summary>Positive test num. 12 - yaml file</summary>

```yaml hl_lines="6"
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test (CloudFormation)
Resources:
  RDSCluster1:
    Type: "AWS::RDS::DBCluster"
    Properties:
      MasterUserPassword: root  # positive1
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

```tf hl_lines="3"
# "Stripe API Key" - 6abcae17-b175-4698-a9a5-b07661974749  positive-test
provider "stripe" {
  api_key = "sk_live_aSaDsEaSaDsEaSaDs29SaDsE"
}

```
</details>
<details><summary>Positive test num. 14 - tf file</summary>

```tf hl_lines="51"
# "Google API Key" - e9856348-4069-4ac0-bd91-415f6a7b84a4  positive-test (line 51)
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

```tf hl_lines="4"
# "Her oku API Key"(extra space to prevent false positive) - 9a3650af-5b88-48cd-ab89-cd77fd0b633f  positive-test
provider "heroku" {
  email   = "ops@company.com"
  api_key = "C71AAAAE-1D1D-1D1D-1D1D-1D1D1D1D1D1D"  # positive1
}

```
</details>
<details><summary>Positive test num. 16 - tf file</summary>

```tf hl_lines="3"
# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc  positive-test
provider "github" {
   token = "we2323232g3hg2h3g2h3g2h3g2h3uh2h3ghg32h3"
}

```
</details>
<details><summary>Positive test num. 17 - tf file</summary>

```tf hl_lines="5"
# "Generic API Key" - 74736dd1-dd11-4139-beb6-41cd43a50317  positive-test
provider "cloudflare" {
  version = "~> 2.0"
  email   = "var.cloudflare_email"
  api_key = "1d2d2dewerdcxeee34c323c3223c223232c32" # positive1
}

```
</details>
<details><summary>Positive test num. 18 - dockerfile file</summary>

```dockerfile hl_lines="11 14 17 20 23"
# "Square Access Token"   - 0b1b2482-51e7-49d1-893d-522afa4a6bd0                                     positive-test   - #1
# "Generic Token"         - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding Square Access Token"    allow-rule-test - #2
# "Picatic API Key"       - 50cc5f03-e686-4183-97e9-12f9b55d0f97                                     positive-test   - #3
# "Amazon MWS Auth Token" - ac8c8075-6ec0-4367-9e26-30ec8161d258                                     positive-test   - #4
# "Generic Token"         - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding Amazon MWS Auth Token"  allow-rule-test - #5 (also detected as TF resource access)
# "MailChimp API Key"     - 6c54f9da-1a11-445a-8568-0d327e6af8be                                     positive-test   - #6
# "SendGrid API Key"      - 8a879bc7-6f82-40fd-bb48-74d25d557fe8                                     positive-test   - #7
FROM baseImage

#1 & #2:
ARG token=sq0atp-812erere3wewew45678901

#3:
ARG picaticKey=sk_live_123as6789o1234567890123a123a5678

#4 & #5:
ARG amazonToken=amzn.mws.643a5678-8f9f-1a2b-5c3b-e3ea43f3f4b4

#6:
ARG mailChimp=f4f56af5a54a3eaeb3c3beb3cc2ccccc-us36

#7:
ARG sgApiK=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

```
</details>
<details><summary>Positive test num. 19 - yaml file</summary>

```yaml hl_lines="10"
# "Generic Private Key" - 2f665079-c383-4b33-896e-88268c1fa258  positive-test
Resources:
  PinpointApp:
    Type: AWS::Pinpoint::App
    Properties:
      Name: foobar
  PinpointAPNSChannel:
    Type: AWS::Pinpoint::APNSChannel
    Properties:
      PrivateKey: b@d0@u7H70K3n # positive1

```
</details>
<details><summary>Positive test num. 20 - yaml file</summary>

```yaml hl_lines="6 23"
# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc  positive-test
Resources:
  ElastiCacheReplicationGroup:
    Type: AWS::ElastiCache::ReplicationGroup
    Properties:
      AuthToken: b@d0@u7H70K3n      # positive1
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
      TokenKey: b@d0@u7H70K3n       # positive2
      ApplicationId: !Ref PinpointApp

```
</details>
<details><summary>Positive test num. 21 - yaml file</summary>

```yaml hl_lines="6"
# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc  positive-test
- name: Start a workflow in the Itential Automation Platform
  community.network.iap_start_workflow:
    iap_port: 3000
    iap_fqdn: localhost
    token_key: "DFSFSFHFGFGF[DSFSFAADAFASD%3D"  # positive1
    workflow_name: "RouterUpgradeWorkflow"
    description: "OS-Router-Upgrade"
    variables: {"deviceName":"ASR9K"}
  register: result

```
</details>
<details><summary>Positive test num. 22 - tf file</summary>

```tf hl_lines="3"
# "Mailgun API Key" - 62d0025d-9575-4eff-b60b-d3b4fcec0d04  positive-test
provider "mailgun" {
  api_key = "key-987ad62adwf1w2w2563adf2ef5323123"
}

```
</details>
<details><summary>Positive test num. 23 - yaml file</summary>

```yaml hl_lines="7"
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test (ansible)
- name: create a cluster1
  google.cloud.gcp_container_cluster:
    name: my-cluster1
    initial_node_count: 2
    master_auth:
      password: root  # positive1
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

```tf hl_lines="3"
# "Stripe Restricted API Key" - 54274b18-bfac-47ce-afd1-0f05bc3e3b59  positive-test
provider "stripe" {
  api_key = "rk_live_aSaDsEaSaDsEaSaDs29SaDsE"
}

```
</details>
<details><summary>Positive test num. 25 - yaml file</summary>

```yaml hl_lines="6"
# "Twilio API Key"  - e0f01838-b1c2-4669-b84b-981949ebe5ed                              positive-test   - #1
# "Generic API Key" - 74736dd1-dd11-4139-beb6-41cd43a50317 - "Avoiding Twilio API Key"  allow-rule-test - #2
- hosts: all
  remote_user: root
  vars:
    twilio_api_key: SKa7CF7acdcaf92Be4CCC52F4a2923BBB3  #1 & #2


```
</details>
<details><summary>Positive test num. 26 - yaml file</summary>

```yaml hl_lines="6"
# "PayPal Braintree Access Token" - 4919b847-e3da-402a-acf8-6cea8e529993                                             positive-test   - #1
# "Generic Token"                 - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding PayPal Braintree Access Token"  allow-rule-test - #2
- hosts: all
  remote_user: root
  vars:
    paypal_access_token: access_token$production$1s2d3f4g5h6j7k8k$1b2b3c4a3a1b2b3c4a3a1b2b3c4a3a1b  #1 & #2


```
</details>
<details><summary>Positive test num. 27 - yaml file</summary>

```yaml hl_lines="17 15"
# "Facebook Access Token" - 5176e805-0cda-44fa-ac96-c092c646180a                                     positive-test    - #1
# "Generic Token"         - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding Facebook Access Token"  allow-rule-test  - #2
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
      value: "EAACEdEose0cBA1bad3afsf2aew"  #1
    - name: SECOND_FACEBOOK_TOKEN
      token: "EAACEdEose0cBA12jiajkdasg9w"  #1 & #2


```
</details>
<details><summary>Positive test num. 28 - yaml file</summary>

```yaml hl_lines="16 15"
# "Square OAuth Secret" - bb51eb1e-0357-44a2-86d7-dd5350cffd43                                    positive-test   - #1
# "Generic Secret"      - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99  - "Avoiding Square OAuth Secret"  allow-rule-test - #2
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
      value: "sq0csp-0p9h7g6f4s3s3s3-4a3ardgwa6ADRDJDDKUFYDYDYDY"  #1
      secret: "sq0csp-0p9h7g6f4s3s3s3-4a3ardgwa6ADRDJDDKUFYDYDYDY" #2


```
</details>
<details><summary>Positive test num. 29 - yaml file</summary>

```yaml hl_lines="15"
# "Google OAuth Access Token" - 41a1ca8d-f466-4084-a8c9-50f8b22200d5                                         positive-test   - #1
# "Generic Token"             - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding Google OAuth Access Token"  allow-rule-test - #2
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
        access-token: ya29.Radftwefewuifdebkw2_23232427t42wdbjsvdjavdajvdadkd #1 & #2
        cmd-args: config config-helper --format=json
        cmd-path: /Users/dave/google-cloud-sdk/bin/gcloud
        expiry: 2021-10-28T15:12:03.000Z
        expiry-key: '{.credential.token_expiry}'
        token-key: '{.credential.access_token}'
      name: gcp

```
</details>
<details><summary>Positive test num. 30 - tf file</summary>

```tf hl_lines="6"
# "Putty User Key File Content" - a007a85e-a2a7-4a81-803a-7a2ca0c65abb  positive-test (line 6)
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

```tf hl_lines="15"
# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99  positive-test
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
      secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" # positive1
    }
  }
}

```
</details>
<details><summary>Positive test num. 32 - yaml file</summary>

```yaml hl_lines="18"
# Global allow rule                - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding CloudFormation intrinsic functions"  allow-rule-test - #1
# "CloudFormation Secret Template" - 0ec60fb3-5b78-4da0-bea0-b854fd9bf8b9                                                  positive-test   - #2
Resources:
     NewAmpApp2:
        Type: AWS::DocDB::DBCluster
        Properties:
          MasterUserPassword: !Sub '{{resolve:secretsmanager:${MyAmpAppSecretManagerRotater}::password}}' #1
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
            SecretStringTemplate: '{"username":"admin"}'  #2
            GenerateStringKey: 'password'
            PasswordLength: 16
            ExcludeCharacters: '"@/\'

```
</details>
<details><summary>Positive test num. 33 - tf file</summary>

```tf hl_lines="4"
# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99  positive-test
locals {
  secrets = {
    clientSecret = "C98D9F6O-1273-4E8A-B8D9-551F7F3OC41"
  }
}

```
</details>
<details><summary>Positive test num. 34 - tf file</summary>

```tf hl_lines="9"
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test
resource "google_container_cluster" "primary1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = "root" # positive1

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

```tf hl_lines="16 17"
# "AWS Context-specific credential" - b751213d-99a5-4005-8524-4bf799ee77a1  positive-test (line 16)
# "AWS Certificate"                 - eb171053-9634-42c3-96e9-c625c8ffe698  positive-test (line 17)
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

```tf hl_lines="7"
# "Asymmetric private key" - 51b5b840-cd0c-4556-98a7-fe5f4def80cf  positive-test (line 7)
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

```tf hl_lines="8"
# "Generic Access Key" - 7f370dd5-eea3-4e5f-8354-3cb2506f9f13  positive-test
data "terraform_remote_state" "intnet" {
  backend = "azurerm"
  config = {
    storage_account_name = "asdsadas"
    container_name       = "dp-prasdasdase-001"
    key                  = "infrastructure.tfstate"
    access_key           = "sdsaljasbdasddsadsa"  # positive1
  }
  workspace = terraform.workspace
}

```
</details>
<details><summary>Positive test num. 38 - yaml file</summary>

```yaml hl_lines="7"
# "Generic Token"   - baee238e-1921-4801-9c3f-79ae1d7b2cbc                         positive-test   - #1
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding CF resolve" allow-rule-test - #2
Resources:
  ElastiCacheReplicationGroup:
    Type: AWS::ElastiCache::ReplicationGroup
    Properties:
      First_AuthToken: 'exposed_token' #1
      Second_AuthToken: '{{resolve:secretsmanager:/elasticache/replicationgroup/authtoken:SecretString:password}}' #2
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

```yaml hl_lines="5 6 7"
# "Encryption Key" - 9fb1cd65-7a07-4531-9bcf-47589d0f82d6  positive-test
- hosts: all
  remote_user: root
  vars:
    encryption_key: aes256_my_super_secret_key_value    # positive1
    encryption_key: Ab3f8G2kL9mN4pQ7                    # positive2
    encryptionkey: 0123456789abcdef                     # positive3


```
</details>
<details><summary>Positive test num. 40 - tf file</summary>

```tf hl_lines="9"
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test
resource "google_container_cluster" "primary1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = local.rds_postgres_is_primary ? var.rds_postgres_password : "null" # positive1

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

```yaml hl_lines="21 22"
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test
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
      - POSTGRES_PASSWORD=postgres  # positive1
      - POSTGRES_PASSWORD=string    # positive2

```
</details>
<details><summary>Positive test num. 42 - tf file</summary>

```tf hl_lines="8 7"
# "Google OAuth"   - d651cca2-2156-4d17-8e76-423e68de5c8b  positive-test - #1
# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99  positive-test - #2
resource "auth0_connection" "google_oauth2" {
  name = "Google-OAuth2-Connection"
  strategy = "google-oauth2"
  options {
    client_id = "53221331-2323wasdfa343rwhthfaf33feaf2fa7f.apps.googleusercontent.com"  #1
    client_secret = "F-oS9Su%}<>[];#"                                                   #2
    allowed_audiences = [ "example.com", "api.example.com" ]
    scopes = [ "email", "profile", "gmail", "youtube" ]
    set_user_root_attributes = "on_each_login"
  }
}

```
</details>
<details><summary>Positive test num. 43 - tf file</summary>

```tf hl_lines="10"
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08                           positive-test   - #1
# Global allow rule  - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF variables" allow-rule-test - #2
resource "google_container_cluster" "primary1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = "varexample" #1

    client_certificate_config {
      issue_client_certificate = true
      password = var.example  #2
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

```yml hl_lines="9"
# "Generic Private Key" - 2f665079-c383-4b33-896e-88268c1fa258                              positive-test   - #1
# "Generic Private Key" - 2f665079-c383-4b33-896e-88268c1fa258 - "Avoiding bash variables"  allow-rule-test - #2
on: workflow_call

stages:
  - build

variables:
  GIT_PRIVATE_KEY: "heythisisaprivatekey!"  #1

jobs:
  job_build:
    stage: build
    script:                                 #2:
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

```tf hl_lines="3"
# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99  positive-test
resource "google_secret_manager_secret_version" "secret-version-basic2" {
  secret = "3gzcGokilvtw2HmCLuPx" # positive1

  secret_data = "secret-data"
}

```
</details>
<details><summary>Positive test num. 46 - yaml file</summary>

```yaml hl_lines="26 22"
# "Generic Password on YAML files when value in tuple" - be0ed753-d304-4363-844a-144050d4006d  positive-test
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
x-ibm-configuration:
  assembly:
  gateway: datapower-api-gateway
  properties:
    mock-proxy-user:
      value: mzpamt66
      description: ""
      encoded: false
    mock-proxy-password:
      value: testpwd        # positive1
      description: ""
      encoded: false
    dev-proxy-password:
      value: testpwd        # positive2
      description: ""
      encoded: false
    dev-target-url:
      value: https://api.insee.fr/entreprises/sirene/V3
      description: ""
      encoded: false
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
tags: []

```
</details>
<details><summary>Positive test num. 47 - dockerfile file</summary>

```dockerfile hl_lines="5"
# "Dockerfile ENV hardcoded password with omitted equals" - f05f238a-2ef0-4c39-9a36-951de1ba6dc9  positive-test
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

```dockerfile hl_lines="6"
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test
FROM baseImage

ENV ARTEMIS_USER=artemis
# positive1:
ENV ARTEMIS_PASSWORD=artemis

RUN apk add --no-cache git \
    && git config \
    --global \
    url."https://${GIT_USER}:${GIT_TOKEN}@github.com".insteadOf \
    "https://github.com"

```
</details>
<details><summary>Positive test num. 49 - json file</summary>

```json hl_lines="55"
{
  "metadata": "'Generic Password' - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test (line 55)",
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
<details><summary>Positive test num. 50 - tf file</summary>

```tf hl_lines="8 14"
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test
variable "linux_vms" {
  description = "positive54.tf"
  type = map(object({
    region                           = string
    size                             = optional(string)
    admin_username                   = optional(string)
    admin_password                   = "optional(sensitive(string))"  # positive1
  }))
  default = {}
}

resource "azurerm_linux_virtual_machine" "vms" {
  admin_password        = try(each.value.admin_password, "exposed_password", null)  # positive2
}
```
</details>
<details><summary>Positive test num. 51 - json file</summary>

```json hl_lines="5"
{
  "metadata": "'Generic Secret' - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99  positive-test (line 5)",
  "Resources": {
    "service-3": {
      "secretValue": "secretVaule1"
    }
  }
}

```
</details>
<details><summary>Positive test num. 52 - proto file</summary>

```proto hl_lines="32 34 36 13 14 15 30"
// "Generic Password"    - 487f4be7-3fd9-4506-a07a-eae252180c08 -                               positive-test   - #1
// "Generic Secret"      - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99 -                               positive-test   - #2
// "Generic Token"       - baee238e-1921-4801-9c3f-79ae1d7b2cbc -                               positive-test   - #3
// "Generic Private Key" - 2f665079-c383-4b33-896e-88268c1fa258 -                               positive-test   - #4
// "Encryption Key"      - 9fb1cd65-7a07-4531-9bcf-47589d0f82d6 -                               positive-test   - #5
// "Generic Password"    - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding Proto File fields"  allow rule test - #6
// "Generic Token"       - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding Proto File fields"  allow-rule-test - #7
// "Encryption Key"      - 9fb1cd65-7a07-4531-9bcf-47589d0f82d6 - "Avoiding Proto File fields"  allow-rule-test - #8

syntax = "proto3";

// This sample should not flag the message defined only the exposed secrets in comments :
// "password" = "test_sample"               #1
// "secret_key" : minimum_ten_characters    #2
// "unsafe_token" : "is_this_safe"          #3

package com.example.security_test.v1;

import "google/protobuf/wrappers.proto";

message InocentMessage {
  google.protobuf.StringValue safe_value = 1;
  double not_a_password = 22222;      // #6
  float not_a_token = 3;              // #7
  string not_an_encryption_key = 4;   // #8
}


extend google.protobuf.FileOptions {                // too generic for an allow rule
   int32 source_retention_password = 12342134                 //#1
      [retention = RETENTION_SOURCE];
   string source_retention_token = 12342135                   //#3
      [retention = RETENTION_SOURCE];
   float source_retention_private_key = 12342137              //#4
      [retention = RETENTION_SOURCE];
   double source_retention_encryption_key = 12342136          //#5
      [retention = RETENTION_SOURCE];
}

```
</details>
<details><summary>Positive test num. 53 - dockerfile file</summary>

```dockerfile hl_lines="10 5"
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test
FROM baseImage

# positive1
ARG password=pass!1213Fs

FROM test2

# positive2
ARG password=pass!1213Fs

```
</details>
<details><summary>Positive test num. 54 - tf file</summary>

```tf hl_lines="9"
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test
resource "google_container_cluster" "primary2" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = "pwd_jsuwauJk212"  # positive1

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
<details><summary>Positive test num. 55 - json file</summary>

```json hl_lines="8 5"
{
  "metadata": "'Generic Password' - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test (line 5/8)",
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
<details><summary>Positive test num. 56 - tf file</summary>

```tf hl_lines="9"
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test
resource "google_container_cluster" "primary4" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = "abcd    s"  # positive1

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
# Generic Negative Test - no secrets (k8s)
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
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF variables" allow-rule-test
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
  password                = var.password  # negative1
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
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF variables" allow-rule-test
resource "auth0_connection" "google_oauth2" {
  name = "Google-OAuth2-Connection"
  strategy = "google-oauth2"
  options {
    client_id     = var.google_client_id
    client_secret = var.google_client_secret  # negative1
    allowed_audiences = [ "example.com", "api.example.com" ]
    scopes = [ "email", "profile", "gmail", "youtube" ]
    set_user_root_attributes = "on_each_login"
  }
}

```
<details><summary>Negative test num. 4 - tf file</summary>

```tf
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF variables"  allow-rule-test
provider "slack" {
  token = var.slack_token # negative1
}

```
</details>
<details><summary>Negative test num. 5 - tf file</summary>

```tf
# "Generic API Key" - 74736dd1-dd11-4139-beb6-41cd43a50317  negative-test ('.' char is illegal in key definition, incorrect key length (17 is not in {32,45}))
provider "stripe" {
  api_key = var.strip_api_key
}

```
</details>
<details><summary>Negative test num. 6 - tf file</summary>

```tf
# Generic Negative Test - several keywords used in safe contexts ("password","api_key","secret_key")
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
# "Generic API Key" - 74736dd1-dd11-4139-beb6-41cd43a50317  negative-test ('.' char is illegal in key definition, incorrect key length (18 is not in {32,45}))
provider "heroku" {
  email   = "ops@company.com"
  api_key = var.heroku_api_key
}

```
</details>
<details><summary>Negative test num. 8 - tf file</summary>

```tf
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF variables"  allow-rule-test
provider "github" {
  token = var.github_key  # negative1
}

```
</details>
<details><summary>Negative test num. 9 - tf file</summary>

```tf
# "Generic API Key" - 74736dd1-dd11-4139-beb6-41cd43a50317  negative-test ('.' char is illegal in key definition, incorrect key length (11 is not in {32,45}))
provider "cloudflare" {
  version = "~> 2.0"
  email   = "var.cloudflare_email"
  api_key = "var.api_key"
}

```
</details>
<details><summary>Negative test num. 10 - yaml file</summary>

```yaml
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding CloudFormation intrinsic functions"  allow-rule-test
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
      PrivateKey: !GetAtt PrivateKey1 # negative1

```
</details>
<details><summary>Negative test num. 11 - yaml file</summary>

```yaml
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding CloudFormation intrinsic functions"  allow-rule-test
Parameters:
  PinpointAPNSVoipChannelTokenKey:
    Type: String
Resources:
  ElastiCacheReplicationGroup:
    Type: AWS::ElastiCache::ReplicationGroup
    Properties:
      AuthToken: !Ref PinpointAPNSVoipChannelTokenKey # negative1
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
      TokenKey: !Ref PinpointAPNSVoipChannelTokenKey # negative2
      ApplicationId: !Ref PinpointApp

```
</details>
<details><summary>Negative test num. 12 - yaml file</summary>

```yaml
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding CloudFormation intrinsic functions"  allow-rule-test
Resources:
  RDSCluster:
    Type: "AWS::RDS::DBCluster"
    Properties:
      MasterUserPassword: !Ref PasswordMaster  # negative1
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
# Generic Negative Test - no secrets
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
# "Generic API Key" - 74736dd1-dd11-4139-beb6-41cd43a50317  negative-test ('.' char is illegal in key definition, incorrect key length (19 is not in {32,45}))
provider "mailgun" {
  api_key = "var.mailgun_api_key"
}

```
</details>
<details><summary>Negative test num. 15 - tf file</summary>

```tf
# "Generic API Key" - 74736dd1-dd11-4139-beb6-41cd43a50317  negative-test ('.' char is illegal in key definition, incorrect key length (28 is not in {32,45}))
provider "stripe" {
  api_key = var.strip_restricted_api_key
}

```
</details>
<details><summary>Negative test num. 16 - yaml file</summary>

```yaml
# "Twilio API Key" - e0f01838-b1c2-4669-b84b-981949ebe5ed  negative-test (is not a hardcoded key)
- hosts: all
  remote_user: root
  vars:
    twilio_api_key: '{{ TWILIO_API_KEY }}'

```
</details>
<details><summary>Negative test num. 17 - yaml file</summary>

```yaml
# "PayPal Braintree Access Token" - 4919b847-e3da-402a-acf8-6cea8e529993  negative-test (is not a hardcoded token)
- hosts: all
  remote_user: root
  vars:
    paypal_access_token: '{{ PAYPAL_ACCESS_TOKEN }}'


```
</details>
<details><summary>Negative test num. 18 - yaml file</summary>

```yaml
# Generic Negative Test - no secrets
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
# "Google OAuth Access Token" - 41a1ca8d-f466-4084-a8c9-50f8b22200d5  negative-test (is not a hardcoded token)
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
        access-token: '{.credential.oauth_access_token_}' # negative1
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
# Generic Negative Test - no secrets
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
# "Generic Token"   - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding TF resource access"  allow-rule-test - #1
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF variables"        allow-rule-test - #2
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding array access"        allow-rule-test - #3
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "auth_token" {
  description = "Authentication token"
  type        = string
  sensitive   = true
}

variable "enabled" {
  description = "Whether to enable resources"
  type        = bool
  default     = true
}

resource "aws_secretsmanager_secret_version" "token_version" {
  for_each = { for k, v in var.clients.oauth : k => v if var.enabled }

  secret_id     = aws_secretsmanager_secret.client_token_secret[each.key].id
  secret_string = jsonencode({ "client" : each.key, "token" : random_password.client_token[each.key].result })  #1
}

resource "aws_secretsmanager_secret_version" "token_version_2" {
  for_each = { for k, v in var.clients.oauth : k => v if var.enabled }

  secret_id     = aws_secretsmanager_secret.client_token_secret[each.key].id
  secret_string = jsonencode({ "client" : each.key, "token" : random_password[each.key].client_token.result }) #1
}

resource "aws_secretsmanager_secret_version" "token_version_3" {
  for_each = { for k, v in var.clients.oauth : k => v if var.enabled }

  secret_id     = aws_secretsmanager_secret.client_token_secret[each.key].id                                   #3
  secret_string = jsonencode({ "client" : each.key, "token" : random_password["index"].client_token.result })
}

resource "aws_lb_listener" "https_null" {
  count             = var.enabled ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type      = "fixed-response"
    token_key = null  #1
  }
}
module "auth_service" {
  source = "./modules/auth"

  token = var.auth_token  #2
}
module "api_gateway" {
  source = "./modules/gateway"

  token = module.auth_service.token_output.value  #1
}
module "legacy_service" {
  source = "./modules/legacy"

  token = data.aws_secretsmanager_secret_version.existing_token.secret_string  #1
}

locals {
  token_config = {
    value = aws_secretsmanager_secret.client_token_secret["primary"].arn
  }
}

module "monitoring" {
  source = "./modules/monitoring"

  token = local.token_config.value  #1
}
```
</details>
<details><summary>Negative test num. 22 - yaml file</summary>

```yaml
# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding Github id-token Default Values"  allow-rule-test
name: Example Workflow

on: workflow_call

jobs:
  build-deploy:
    permissions:
      contents: read
      pages: write
      id-token: write # negative1

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
      id-token: read # negative2

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
      id-token: none # negative3

    runs-on: ubuntu

    steps:
      - uses: actions/checkout@v4

```
</details>
<details><summary>Negative test num. 23 - yaml file</summary>

```yaml
# Generic Negative Test - no secrets (ansible)
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
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding Boolean's"  allow-rule-test
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  automountServiceAccountToken: false # negative1
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
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding arn"  allow-rule-test
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
        encryption_key: 'arn:aws:kms:{{ aws_region }}:{{ aws_account_id }}:alias/aws/s3'  # negative1
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
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding CloudFormation intrinsic functions"  allow-rule-test
Conditions:
  HasKmsKey: !Not [!Equals [!Ref ParentKmsKeyStack, '']]
  HasSecretName: !Not [!Equals [!Ref ParentKmsKeyStack, '']]
  HasPassword: !Not [!Equals [!Ref DBPassword, '']] # negative1
Resources:
```
</details>
<details><summary>Negative test num. 27 - yaml file</summary>

```yaml
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding TF resource access" allow-rule-test - #1 (line 10)
# Global allow rule  - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding Boolean's"          allow-rule-test - #2 (line 11)
Resources:
  LambdaFunctionV2:
    Type: 'AWS::Lambda::Function'
    Properties:
      Code:       #1 & #2:
        ZipFile: |
                AllowUsersToChangePassword: event.ResourceProperties.AllowUsersToChangePassword === 'true',
                AllowUsersToChangePassword: false,
      Handler: 'index.handler'
      MemorySize: 128
      Role: !GetAtt 'LambdaRole.Arn'
      Runtime: 'nodejs12.x'
      Timeout: 60

```
</details>
<details><summary>Negative test num. 28 - tf file</summary>

```tf
# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99  - "Avoiding TF resource access"  allow-rule-test
locals {
  secrets = {
    my_secret = random_password.my_password.result
  }
}

```
</details>
<details><summary>Negative test num. 29 - dockerfile file</summary>

```dockerfile
# Generic Negative Test - arbitrary git "token" references (dockerfile)
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
# Global allow rule  - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF file function"  allow-rule-test
resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  connection {
    user        = "ubuntu"
    private_key = file(var.private_key_path)  # negative1
  }
}

```
</details>
<details><summary>Negative test num. 31 - yaml file</summary>

```yaml
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding array access"  allow-rule-test (line 10/11)
Resources:
  MytFunction:
    Type: AWS::Lambda::Function
    Properties:
      FunctionName: !Sub '${AWS::StackName}-CdnViewerRequest'
      Code:
        ZipFile: !Sub | # negative1:
          function msg(userPass) {
            return {"username": userPass[1], "password": userPass[2]}
            return {"Busername": userPass[1312], "Bpassword": userPass[2412]}
          }

```
</details>
<details><summary>Negative test num. 32 - yaml file</summary>

```yaml
# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99  - "Avoiding Secrets Manager arn"  allow-rule-test
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
                - :secretsmanager:eu-west-1:1111111111111:secret:/test/resources/docdb-test:SecretString:endpoint::}}/test  # negative1
          USERNAME:
            Fn::Join:
              - ""
              - - "{{resolve:secretsmanager:arn:"
                - Ref: AWS::Partition
                - :secretsmanager:eu-west-1:1111111111111:secret:/test/resources/docdb-test:SecretString:username::}}       # negative2
          PASSWORD:
            Fn::Join:
              - ""
              - - "{{resolve:secretsmanager:arn:"
                - Ref: AWS::Partition
                - :secretsmanager:eu-west-1:1111111111111:secret:/test/resources/docdb-test:SecretString:password::}}        # negative3
          JDBC_ENFORCE_SSL: true
      ConnectionType: MONGODB

```
</details>
<details><summary>Negative test num. 33 - yaml file</summary>

```yaml
# "Encryption Key" - 9fb1cd65-7a07-4531-9bcf-47589d0f82d6 - "Avoiding CloudFormation KeyName"  allow-rule-test
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
      EncryptionKey: somekey      # negative1
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
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF variables" allow-rule-test
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
  secret = var.my_google_secret # negative1

  secret_data = "secret-data"
}

```
</details>
<details><summary>Negative test num. 35 - yaml file</summary>

```yaml
# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99  - "Avoiding Secrets Manager arn"  allow-rule-test
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
                - :secretsmanager:*:1111111111111:secret:/test/resources/docdb-test:SecretString:endpoint::}}/test  # negative1
          USERNAME:
            Fn::Join:
              - ""
              - - "{{resolve:secretsmanager:arn:"
                - Ref: AWS::Partition
                - :secretsmanager:eu-west-1:*:secret:/test/resources/docdb-test:SecretString:username::}}           # negative2
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
# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding CloudFormation ServiceToken"  allow-rule-test
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
      ServiceToken: anArn                       # negative1
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
# Global allow rule  - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF file function"  allow-rule-test
data "terraform_remote_state" "intnet" {
  backend = "azurerm"
  config = {
    storage_account_name = "asdsadas"
    container_name       = "dp-prasdasdase-001"
    key                  = "infrastructure.tfstate"
    access_key           = file(var.access_key_path)  # negative1
  }
  workspace = terraform.workspace
}

```
</details>
<details><summary>Negative test num. 38 - tf file</summary>

```tf
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding TF resource access"  allow-rule-test
resource "google_container_cluster" "primary1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = local.rds_postgres_is_primary ? var.rds_postgres_password : null # negative1

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
# "Generic Private Key" - 2f665079-c383-4b33-896e-88268c1fa258 - "Avoiding bash variables"  allow-rule-test
on: workflow_call

stages:
  - build

variables:
  GIT_PRIVATE_KEY: $GIT_PRIVATE_KEY

jobs:
  job_build:
    stage: build
    script: # negative1:
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
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding Ansible playbook update_password"  allow-rule-test
- name: "Configure the MySQL user "
  community.mysql.mysql_user:
    login_user: "root"
    login_password: "{{ mysql_root_password }}"
    name: "{{ mysql_user }}"
    password: "{{ mysql_user_password }}"
    password_expire: "never"
    update_password: "on_create"    # negative1

```
</details>
<details><summary>Negative test num. 41 - yaml file</summary>

```yaml
# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99 - "Avoiding Secrets from Variable Interpolation"  allow-rule-test - (lines 51/73)
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
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding TF resource access"  allow-rule-test
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
  admin_password      = data.azurerm_key_vault_secret.LinuxVmPassword.value # negative1

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
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding TF resource access"  allow-rule-test
data "template_file" "sci_integration_app_properties_secret_template" {
  template = file(join("", ["/secrets/sci-integration-app", var.resource_identifier_shorthand], ".json"))

  vars = {  # negative1-11
    ayreshirerarran_password     = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["ayreshirerarran_password"]
    lanark_password              = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["lanark_password"]
    tayside_password             = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["tayside_password"]
    glasgow_password             = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["glasgow_password"]
    grampian_password            = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["grampian_password"]
    highland_password            = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["highland_password"]
    westernisles_password        = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["westernisles_password"]
    dumfriesandgalloway_password = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["dumfriesandgalloway_password"]
    forthvalley_password         = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["forthvalley_password"]
    borders_password             = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["borders_password"]
    lothian_password             = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["lothian_password"]
  }
}

```
</details>
<details><summary>Negative test num. 44 - dockerfile file</summary>

```dockerfile
# Generic Negative Test - arbitrary git "token" references, ARTEMIS_PASSWORD missing (dockerfile)
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
# Generic Negative Test - no secrets (dockerfile)
FROM baseImage

RUN command

```
</details>
<details><summary>Negative test num. 46 - dockerfile file</summary>

```dockerfile
# Generic Negative Test - arbitrary git "token" references, ARTEMIS_PASSWORD missing (dockerfile)
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
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Allow placeholders"  allow-rule-test - #1
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Allow empty values"  allow-rule-test - #2
stages:
- template: templates/main-stage.yml
  parameters:
    environment:                      'foo'
    isSm9ChangeRequired:              true

    isDedicatedSubscription:          'true'
    setResourceLock:                  'true'
    nameResourceLock:                 'PrdPreventAccidentalDeletion'
    isDevelopment:                    'false'

    vmAdminPassword:                  '$(VM_ADMIN_PASSWORD)'          #1
    sqlAdminPassword:                 '$(SQL_ADMIN_PASSWORD)'         #1
    yetanotherAdminPassword:          '${{SQL_ADMIN_PASSWORD}}'       #1
    andyetanotherAdminPassword:       '${{ SQL_ADMIN_PASSWORD }}'     #1

    # example 2 (empty string value)
    anotherAdminPassword:             ''  #2

    serviceConnectionName:            'foo'
    subscriptionId:                   'foo'
    organisationalGroup:              'foo'




```
</details>
<details><summary>Negative test num. 48 - yml file</summary>

```yml
# "Generic Private Key" - 2f665079-c383-4b33-896e-88268c1fa258 - "Avoid Docker Compose secrets paths"  allow-rule-test
version: '3.7'

services:
  apis:
    image: ""
    env_file:
      - .env
    environment:
      env: "dev"

      PrivateKey: /run/secrets/SOME_AUTHORIZATION_PRIVATE_KEY # negative1

secrets:
  SOME_AUTHORIZATION_PRIVATE_KEY:
    external: true


```
</details>
<details><summary>Negative test num. 49 - json file</summary>

```json
{
  "metadata" : "# 'Generic Password' - 487f4be7-3fd9-4506-a07a-eae252180c08 - 'Allow password retrieved from ARM parameters' allow rule test (line 12)",
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
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
```
</details>
<details><summary>Negative test num. 50 - json file</summary>

```json
{
  "metadata": "'Generic Secret' - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99 - 'Allow secret retrieved from ARM parameters'  allow-rule-test (line 11)",
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "apiSecret": {
      "type": "secureString"
    }
  },
  "variables": {
    "connectionSecret": "[parameters('apiSecret')]"
  },
  "resources": []
}
```
</details>
<details><summary>Negative test num. 51 - yml file</summary>

```yml
# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding Github id-token Default Values"  allow-rule-test
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
       #id-token: write # for oidc npm provenance                             # negative1
       #"id-token": read                                                      # negative2
       #'id-token': none                                                      # negative3
       #permissions: {id-token: write, contents: read, pull-requests: write}  # negative4
    steps:
      - name: debug
        shell: bash
        run: |
          echo 'github.event_actor=${{ github.event_actor }}'
```
</details>
<details><summary>Negative test num. 52 - tf file</summary>

```tf
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding description field"               allow-rule-test - #1
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding Terraform 'optional' statement"  allow-rule-test - #2
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding Terraform 'try' statement"       allow-rule-test - #3
variable "linux_vms" {
  # 1:
  description = "A list of the Linux VMs to create.  \n <a name=region:></a>[region:](#region:) The Azure location where the Windows Virtual Machine should exist. Changing this forces a new resource to be created.  \n <a name=size:></a>[size:](#size:) The SKU which should be used for this Virtual Machine, such as Standard_F2.  \n <a name=admin_username:></a>[admin_username:](#admin_username:) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created.  \n <a name=admin_password:></a>[admin_password:](#admin_password:) he Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created."
  type = map(object({
    region                           = string
    size                             = optional(string)
    admin_username                   = optional(string)
    admin_password                   = optional(string) #2
  }))
  default = {}
}

resource "azurerm_linux_virtual_machine" "vms" {
  admin_password        = try(each.value.admin_password, null)  #3
}
```
</details>
<details><summary>Negative test num. 53 - bicep file</summary>

```bicep
// "Generic Secret"   - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99 - 'Allow secrets retrieved from Bicep getSecret built in function'  allow-rule-test
import { common, tagsObject, deployName, removeSpace } from '../../../CommonValues.bicep'

@description('Nome do sistema')
param systemName string

@description('Nome do recurso')
param resourceName string = removeSpace(systemName)

@description('Enterprise Tagging object')
param tags tagsObject

resource kvTest 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: 'kv-test-sample'
  scope: resourceGroup('rg-test-sample')
}

module consumerModule '../SecretConsumer/Resource.bicep' = {
  name: deployName(resourceName, 'Test.SecretConsumer', tags.lastReleaseId)
  params: {
    systemName: systemName
    resourceName: resourceName
    tags: tags
    apiClientSecret: kvTest.getSecret('secret-sample')  // negative1
  }
}

```
</details>
<details><summary>Negative test num. 54 - json file</summary>

```json
{
    "metadata": "'Generic Token' - baee238e-1921-4801-9c3f-79ae1d7b2cbc - 'Avoiding Run After Triggers (if written in conformity with best practices)'  allow-rule-test",
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
            "type": "Microsoft.Logic/workflows",
            "apiVersion": "[parameters('apiVersion')]",
            "name": "[parameters('logicAppName')]",
            "location": "centralus",
            "properties": {},
            "actions": {
                "Sample_action_1": {
                    "runAfter_164": {
                        "HTTP_-_Get_OAuth_Token": [
                            "Succeeded"
                        ]
                    }
                },
                "Sample_action_2": {
                    "runAfter_192": {
                        "Parse_JSON_-_OAuth_Token": [
                            "Succeeded"
                        ]
                    }
                },
                "Sample_action_3": {
                    "runAfter_240": {
                        "Try_-_Get_OAuth_Token": [
                            "TimedOut",
                            "Failed"
                        ]
                    }
                },
                "Sample_action_4": {
                    "runAfter_678": {
                        "Catch_-_Get_OAuth_Token": [
                            "Skipped"
                        ]
                    }
                }
            }
        }
    ]
}
```
</details>
<details><summary>Negative test num. 55 - bicep file</summary>

```bicep
// "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding references to module outputs in Bicep"  allow-rule-test (also avoided by TF resource access allow rule)
param systemName string
param resourceName string
param tags object
param originUrl string

module myModule '../AnotherModule/Resource.bicep' = {
  name: '${resourceName}-MyModule'
  params: {
    systemName: systemName
    resourceName: resourceName
    tags: tags
    apiUrl: originUrl
  }
}

module clientModule '../ClientModule/Resource.bicep' = {
  name: '${resourceName}-ClientModule'
  params: {
    systemName: systemName
    resourceName: resourceName
    tags: tags
    // negative1:
    validationToken: myModule.outputs.apiToken
  }
}

// Saída do módulo
output clientUrl string = clientModule.outputs.clientUrl
output clientName string = clientModule.outputs.clientName

```
</details>
<details><summary>Negative test num. 56 - json file</summary>

```json
{
  "metadata": "Generic Negative Test - no secrets",
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
<details><summary>Negative test num. 57 - proto file</summary>

```proto
// "Generic Token"       - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding Proto File fields"   allow-rule-test - #1
// "Generic Private Key" - 2f665079-c383-4b33-896e-88268c1fa258 - "Avoiding Proto File fields"   allow rule test - #2
// "Encryption Key"      - 9fb1cd65-7a07-4531-9bcf-47589d0f82d6 - "Avoiding Proto File fields"   allow-rule-test - #3
// "Generic Password"    - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding Proto File fields"   allow rule test - #4
// "Generic Secret"      - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99 - "Avoiding Proto File fields"   allow rule test - #5
// Global allow rule     - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding Boolean's"           allow-rule-test - #6
syntax = "proto3";
package com.example.security_test.v1;
import "google/protobuf/wrappers.proto";
option go_package = "github.com/CheckmarxDev/router-audit/gen/presets/v1;presets";

// Scenario 1 - Simple attribution
message SampleMessageNegative {
  google.protobuf.StringValue refresh_token = 536870911; // if value is larger - out of range error "Field numbers cannot be greater than 536870911."  - Generic Token #1
  google.protobuf.StringValue sonar_token = 39;google.protobuf.StringValue codecov_token = 40;// trailing comment test - Generic Token #1

  google.protobuf.StringValue access_token= 111111111;                             // Generic Token #1
  google.protobuf.StringValue    api_token = 7   ;                                 // Generic Token #1
  google.protobuf.StringValue token = 8;                                           // Generic Token #1
  google.protobuf.StringValue aws_session_token = 9;                               // Generic Token #1
  google.protobuf.StringValue twilio_auth_token = 21;                              // Generic Token #1
  google.protobuf.StringValue test_token_ = 122  ;                                 // Generic Token #1

  google.protobuf.StringValue jwt_private_key = 25;                                // Generic Private Key #2
  google.protobuf.StringValue ssh_private_key = 26;                                // Generic Private Key #2
  google.protobuf.StringValue tls_private_key = 27;                                // Generic Private Key #2
  google.protobuf.StringValue ca_private_key = 28    ;                             // Generic Private Key #2
  google.protobuf.StringValue private_key = 5;                                     // Generic Private Key #2

  google.protobuf.StringValue encryption_key = 22;                                 // Encryption Key #3
  google.protobuf.StringValue data_encryption_key= 23   ;                          // Encryption Key #3
  google.protobuf.StringValue key_encryption_key=24;                               // Encryption Key #3

  google.protobuf.StringValue registry_password =    10421;                        // Generic Password #4
  google.protobuf.StringValue artifactory_password   = 10731  ;                    // Generic Password #4
  google.protobuf.StringValue nexus_password = 10853;                              // Generic Password #4
  string password =          64114;                                                // Generic Password #4

  string secret_key =   123456789;                                                 // Generic Secret #5
  string secret_value   = 123456790;                                               // Generic Secret #5
  string   secret   =   123456791;                                                 // Generic Secret #5
}

// Scenario 2 - Attribution with options
message SampleMessageNegative2 {
  google.protobuf.StringValue next_page_token = 5 [(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"test\""}];        // Generic Token #1
  google.protobuf.StringValue next_next_page_token = 6[(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"test\""}  ] ; // Generic Token #1
  google.protobuf.StringValue api_token = 7 [(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"jira_api_token\""}];    // Generic Token #1

  google.protobuf.StringValue next_page_private_key = 8 [(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"test\""}];             // Generic Private Key #2
  google.protobuf.StringValue next_next_page_private_key = 8[(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"test\""}  ] ;      // Generic Private Key #2
  google.protobuf.StringValue api_private_key = 10 [(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"jira_api_private_key\""}];  // Generic Private Key #2

  google.protobuf.StringValue next_page_encryption_key = 11 [(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"test\""}];                // Encryption Key #3
  google.protobuf.StringValue next_next_page_encryption_key = 12[(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"test\""}  ] ;         // Encryption Key #3
  google.protobuf.StringValue api_encryption_key = 13 [(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"jira_api_encryption_key\""}];   // Encryption Key #3

  google.protobuf.StringValue next_page_password = 14 [(grpc.gateway.protoc_gen_openapiv2.options.openapiv2_field) = {example: "\"test\""}];          // Generic Password #4
  google.protobuf.StringValue next_next_page_password = 15[(grpc.gateway.protoc_gen_openapiv2.options.openapiv2_field) = {example: "\"test\""}  ] ;   // Generic Password #4
  google.protobuf.StringValue api_password = 16 [(grpc.gateway.protoc_gen_openapiv2.options.openapiv2_field) = {example: "\"jira_api_password\""}];   // Generic Password #4

  google.protobuf.StringValue next_page_secret = 17[(grpc.gateway.protoc_gen_openapiv2.options.openapiv2_field) = {example: "\"test\""}];           // Generic Secret #5
  google.protobuf.StringValue next_next_page_secret = 18[(grpc.gateway.protoc_gen_openapiv2.options.openapiv2_field) = {example: "\"test\""}  ] ;   // Generic Secret #5
  google.protobuf.StringValue api_secret = 19[(grpc.gateway.protoc_gen_openapiv2.options.openapiv2_field) = {example: "\"jira_api_secret\""}];      // Generic Secret #5
}

message MyOptions {
  string file_only_option_token = 1 [targets = TARGET_TYPE_FILE];                     // Generic Token       #1
  int message_and_enum_option_token = 2 [targets = TARGET_TYPE_MESSAGE,
                                     targets = TARGET_TYPE_ENUM];                     // Generic Token       #1 (line above)

  string file_only_option_private_key = 11 [targets = TARGET_TYPE_FILE];              // Generic Private Key #2
  int message_and_enum_option_private_key = 21 [targets = TARGET_TYPE_MESSAGE,
                                     targets = TARGET_TYPE_ENUM];                     // Generic Private Key #2 (line above)

  string file_only_option_encryption_key = 13 [targets = TARGET_TYPE_FILE];           // Encryption Key      #3
  int message_and_enum_option_encryption_key = 23 [targets = TARGET_TYPE_MESSAGE,
                                     targets = TARGET_TYPE_ENUM];                     // Encryption Key      #3 (line above)

  string file_only_option_password = 14 [targets = TARGET_TYPE_FILE];                 // Generic Password    #4
  int message_and_enum_option_password = 24 [targets = TARGET_TYPE_MESSAGE,
                                     targets = TARGET_TYPE_ENUM];                     // Generic Password    #4 (line above)

  string file_only_option_secret = 15[targets = TARGET_TYPE_FILE];                    // Generic Secret      #5
  int message_and_enum_option_secret = 25[targets = TARGET_TYPE_MESSAGE,
                                     targets = TARGET_TYPE_ENUM];                     // Generic Secret      #5 (line above)

  int B_message_and_enum_option_token = 2 [targets = TARGET_TYPE_MESSAGE, targets = TARGET_TYPE_ENUM];              // Generic Token        #1

  int B_message_and_enum_option_private_key = 211 [targets = TARGET_TYPE_MESSAGE, targets = TARGET_TYPE_ENUM];      // Generic Private Key  #2

  int B_message_and_enum_option_encryption_key = 232 [targets = TARGET_TYPE_MESSAGE, targets = TARGET_TYPE_ENUM];   // Encryption Key       #3

  int B_message_and_enum_option_password = 243 [targets = TARGET_TYPE_MESSAGE, targets = TARGET_TYPE_ENUM];         // Generic Password     #4

  int B_message_and_enum_option_secret = 254[targets = TARGET_TYPE_MESSAGE, targets = TARGET_TYPE_ENUM];            // Generic Secret       #5
}

message Not_a_Token {
  string token          = 1  [json_name = "tk"];          // Generic Token       #1
  string private_key    = 4  [json_name = "pk"];          // Generic Private Key #2
  string encryption_key = 3  [json_name = "ek"];          // Encryption Key      #3
  string password       = 2  [json_name = "ps"];          // Generic Password    #4
  string secret         = 5[json_name = "se"];            // Generic Secret      #5
}

// Scenario 3 - Enum attributions
enum Corpus {
  DATA_A_UNSPECIFIED_TOKEN = 0 [  deprecated =   true  ] ;    // Generic Token       #1
  DATA_A_TOKEN = 11[deprecated=true] ;                        // Generic Token       #1 & #6
  DATA_A_PRIVATE_KEY = 2[deprecated = false];                 // Generic Private Key #2 & #6
  DATA_A_ENCRYPTION_KEY = 3[deprecated = true];               // Encryption Key      #3 & #6
  DATA_A_PASSWORD = 1234  [deprecated = false];               // Generic Password    #4 & #6
  DATA_A_SECRET = 5[deprecated=true];                         // Generic Secret      #5 & #6

                                                        // Generic Token       #1 (line below)
  DATA_B_TOKEN = 2[
    (string_name) = "display_value"
  ];
                                                        // Generic Private Key #2 (line below)
  DATA_B_PRIVATE_KEY = 2 [
    (string_name) = "display_value"
  ];
                                                        // Encryption Key      #3 (line below)
  DATA_B_ENCRYPTION_KEY = 2 [
    (string_name) = "display_value"
  ];
                                                        // Generic Password    #4 (line below)
  DATA_B_PASSWORD = 28970[
    (string_name) = "display_value"
  ];
                                                        // Generic Secret      #5 (line below)
  DATA_B_SECRET = 123456789[
    (string_name) = "display_value"
  ];
}

// Scenario 4 - Generic keywords in "reserved"
enum EnumAllowingAlias {
  reserved "password", "api_token", "private_key", "encryption_key", "exposed_secret";
  option end_of_sample = false;}enum InlineMessageFormat{option end_of_sample = true;}
```
</details>
<details><summary>Negative test num. 58 - tf file</summary>

```tf
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding TF resource access"                   allow-rule-test - #1
# Global allow rule  - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding array access"                         allow-rule-test - #2
# "Generic Secret"   - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99 - "Avoiding TF resource access"                   allow-rule-test - #3
# "Generic Secret"   - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99 - "Avoiding Secrets from Variable Interpolation"  allow-rule-test - #4

resource "aws_secretsmanager_secret_version" "secret_version" {
  for_each = { for k, v in var.clients.scram : k => v if var.enabled && var.client_sasl_scram_enabled }

  secret_id     = aws_secretsmanager_secret.client_secret[each.key].id                                                                                              # use of indexes
  #1:
  secret_string = jsonencode({ "username" : join("_", [var.product, each.key, var.environment == "dev" ? var.environment : var.stack]), "password" : random_password.client_password[each.key].result })
}

resource "aws_secretsmanager_secret_version" "secret_version_2" {
  for_each = { for k, v in var.clients.scram : k => v if var.enabled && var.client_sasl_scram_enabled }

  secret_id     = aws_secretsmanager_secret.client_secret[each.key].id                                                                                              # use of indexes
  #1:
  secret_string = jsonencode({ "username" : join("_", [var.product, each.key, var.environment == "dev" ? var.environment : var.stack]), "password" : random_password[each.key].client_password.result })
}

resource "aws_secretsmanager_secret_version" "secret_version_3" {
  for_each = { for k, v in var.clients.scram : k => v if var.enabled && var.client_sasl_scram_enabled }

  secret_id     = aws_secretsmanager_secret.client_secret[each.key].id                                                                                              # use of indexes
  #2:
  secret_string = jsonencode({ "username" : join("_", [var.product, each.key, var.environment == "dev" ? var.environment : var.stack]), "password" : random_password["index"].client_password.result })
}

resource "aws_msk_scram_secret_association" "msk_secret_association" {
  count           = var.enabled && var.client_sasl_scram_enabled ? 1 : 0
  cluster_arn     = aws_msk_cluster.kafka[0].arn
  secret_arn_list = [for secret in aws_secretsmanager_secret.client_secret : secret.arn]     #3
}

resource "aws_msk_scram_secret_association" "msk_secret_association_2" {
  count           = var.enabled && var.client_sasl_scram_enabled ? 1 : 0
  cluster_arn     = aws_msk_cluster.kafka[0].arn
  secret_arn_list = [for secret in aws_secretsmanager_secret.client_secret : "${secret.arn}"] #4
}
```
</details>
<details><summary>Negative test num. 59 - proto file</summary>

```proto
// "Generic Token"       - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding Proto File fields"   allow-rule-test - #1
// "Generic Private Key" - 2f665079-c383-4b33-896e-88268c1fa258 - "Avoiding Proto File fields"   allow rule test - #2
// "Encryption Key"      - 9fb1cd65-7a07-4531-9bcf-47589d0f82d6 - "Avoiding Proto File fields"   allow-rule-test - #3
// "Generic Password"    - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding Proto File fields"   allow rule test - #4
// "Generic Secret"      - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99 - "Avoiding Proto File fields"   allow rule test - #5
// Global allow rule     - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding Boolean's"           allow-rule-test - #6
syntax = "proto3";
package com.example.security_test.v1;
import "google/protobuf/wrappers.proto";
option go_package = "github.com/CheckmarxDev/router-audit/gen/presets/v1;presets";

// Scenario 1 - Simple attribution
message SampleMessageNegative {
  google.protobuf.StringValue refresh_token = 536870911; // if value is larger - out of range error "Field numbers cannot be greater than 536870911."  - Generic Token #1
  google.protobuf.StringValue sonar_token = 39;google.protobuf.StringValue codecov_token = 40;// trailing comment test - Generic Token #1

  google.protobuf.StringValue access_token= 111111111;                             // Generic Token #1
  google.protobuf.StringValue    api_token = 7   ;                                 // Generic Token #1
  google.protobuf.StringValue token = 8;                                           // Generic Token #1
  google.protobuf.StringValue aws_session_token = 9;                               // Generic Token #1
  google.protobuf.StringValue twilio_auth_token = 21;                              // Generic Token #1
  google.protobuf.StringValue test_token_ = 122  ;                                 // Generic Token #1

  google.protobuf.StringValue jwt_private_key = 25;                                // Generic Private Key #2
  google.protobuf.StringValue ssh_private_key = 26;                                // Generic Private Key #2
  google.protobuf.StringValue tls_private_key = 27;                                // Generic Private Key #2
  google.protobuf.StringValue ca_private_key = 28    ;                             // Generic Private Key #2
  google.protobuf.StringValue private_key = 5;                                     // Generic Private Key #2

  google.protobuf.StringValue encryption_key = 22;                                 // Encryption Key #3
  google.protobuf.StringValue data_encryption_key= 23   ;                          // Encryption Key #3
  google.protobuf.StringValue key_encryption_key=24;                               // Encryption Key #3

  google.protobuf.StringValue registry_password =    10421;                        // Generic Password #4
  google.protobuf.StringValue artifactory_password   = 10731  ;                    // Generic Password #4
  google.protobuf.StringValue nexus_password = 10853;                              // Generic Password #4
  string password =          64114;                                                // Generic Password #4

  string secret_key =   123456789;                                                 // Generic Secret #5
  string secret_value   = 123456790;                                               // Generic Secret #5
  string   secret   =   123456791;                                                 // Generic Secret #5
}

// Scenario 2 - Attribution with options
message SampleMessageNegative2 {
  google.protobuf.StringValue next_page_token = 5 [(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"test\""}];        // Generic Token #1
  google.protobuf.StringValue next_next_page_token = 6[(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"test\""}  ] ; // Generic Token #1
  google.protobuf.StringValue api_token = 7 [(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"jira_api_token\""}];    // Generic Token #1

  google.protobuf.StringValue next_page_private_key = 8 [(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"test\""}];             // Generic Private Key #2
  google.protobuf.StringValue next_next_page_private_key = 8[(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"test\""}  ] ;      // Generic Private Key #2
  google.protobuf.StringValue api_private_key = 10 [(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"jira_api_private_key\""}];  // Generic Private Key #2

  google.protobuf.StringValue next_page_encryption_key = 11 [(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"test\""}];                // Encryption Key #3
  google.protobuf.StringValue next_next_page_encryption_key = 12[(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"test\""}  ] ;         // Encryption Key #3
  google.protobuf.StringValue api_encryption_key = 13 [(grpc.gateway.protoc_gen_openapiv3.options.openapiv3_field) = {example: "\"jira_api_encryption_key\""}];   // Encryption Key #3

  google.protobuf.StringValue next_page_password = 14 [(grpc.gateway.protoc_gen_openapiv2.options.openapiv2_field) = {example: "\"test\""}];          // Generic Password #4
  google.protobuf.StringValue next_next_page_password = 15[(grpc.gateway.protoc_gen_openapiv2.options.openapiv2_field) = {example: "\"test\""}  ] ;   // Generic Password #4
  google.protobuf.StringValue api_password = 16 [(grpc.gateway.protoc_gen_openapiv2.options.openapiv2_field) = {example: "\"jira_api_password\""}];   // Generic Password #4

  google.protobuf.StringValue next_page_secret = 17[(grpc.gateway.protoc_gen_openapiv2.options.openapiv2_field) = {example: "\"test\""}];           // Generic Secret #5
  google.protobuf.StringValue next_next_page_secret = 18[(grpc.gateway.protoc_gen_openapiv2.options.openapiv2_field) = {example: "\"test\""}  ] ;   // Generic Secret #5
  google.protobuf.StringValue api_secret = 19[(grpc.gateway.protoc_gen_openapiv2.options.openapiv2_field) = {example: "\"jira_api_secret\""}];      // Generic Secret #5
}

message MyOptions {
  string file_only_option_token = 1 [targets = TARGET_TYPE_FILE];                     // Generic Token       #1
  int message_and_enum_option_token = 2 [targets = TARGET_TYPE_MESSAGE,
                                     targets = TARGET_TYPE_ENUM];                     // Generic Token       #1 (line above)

  string file_only_option_private_key = 11 [targets = TARGET_TYPE_FILE];              // Generic Private Key #2
  int message_and_enum_option_private_key = 21 [targets = TARGET_TYPE_MESSAGE,
                                     targets = TARGET_TYPE_ENUM];                     // Generic Private Key #2 (line above)

  string file_only_option_encryption_key = 13 [targets = TARGET_TYPE_FILE];           // Encryption Key      #3
  int message_and_enum_option_encryption_key = 23 [targets = TARGET_TYPE_MESSAGE,
                                     targets = TARGET_TYPE_ENUM];                     // Encryption Key      #3 (line above)

  string file_only_option_password = 14 [targets = TARGET_TYPE_FILE];                 // Generic Password    #4
  int message_and_enum_option_password = 24 [targets = TARGET_TYPE_MESSAGE,
                                     targets = TARGET_TYPE_ENUM];                     // Generic Password    #4 (line above)

  string file_only_option_secret = 15[targets = TARGET_TYPE_FILE];                    // Generic Secret      #5
  int message_and_enum_option_secret = 25[targets = TARGET_TYPE_MESSAGE,
                                     targets = TARGET_TYPE_ENUM];                     // Generic Secret      #5 (line above)

  int B_message_and_enum_option_token = 2 [targets = TARGET_TYPE_MESSAGE, targets = TARGET_TYPE_ENUM];              // Generic Token        #1

  int B_message_and_enum_option_private_key = 211 [targets = TARGET_TYPE_MESSAGE, targets = TARGET_TYPE_ENUM];      // Generic Private Key  #2

  int B_message_and_enum_option_encryption_key = 232 [targets = TARGET_TYPE_MESSAGE, targets = TARGET_TYPE_ENUM];   // Encryption Key       #3

  int B_message_and_enum_option_password = 243 [targets = TARGET_TYPE_MESSAGE, targets = TARGET_TYPE_ENUM];         // Generic Password     #4

  int B_message_and_enum_option_secret = 254[targets = TARGET_TYPE_MESSAGE, targets = TARGET_TYPE_ENUM];            // Generic Secret       #5
}

message Not_a_Token {
  string token          = 1  [json_name = "tk"];          // Generic Token       #1
  string private_key    = 4  [json_name = "pk"];          // Generic Private Key #2
  string encryption_key = 3  [json_name = "ek"];          // Encryption Key      #3
  string password       = 2  [json_name = "ps"];          // Generic Password    #4
  string secret         = 5[json_name = "se"];            // Generic Secret      #5
}

// Scenario 3 - Enum attributions
enum Corpus {
  DATA_A_UNSPECIFIED_TOKEN = 0 [  deprecated =   true  ] ;    // Generic Token       #1
  DATA_A_TOKEN = 11[deprecated=true] ;                        // Generic Token       #1 & #6
  DATA_A_PRIVATE_KEY = 2[deprecated = false];                 // Generic Private Key #2 & #6
  DATA_A_ENCRYPTION_KEY = 3[deprecated = true];               // Encryption Key      #3 & #6
  DATA_A_PASSWORD = 1234  [deprecated = false];               // Generic Password    #4 & #6
  DATA_A_SECRET = 5[deprecated=true];                         // Generic Secret      #5 & #6

                                                        // Generic Token       #1 (line below)
  DATA_B_TOKEN = 2[
    (string_name) = "display_value"
  ];
                                                        // Generic Private Key #2 (line below)
  DATA_B_PRIVATE_KEY = 2 [
    (string_name) = "display_value"
  ];
                                                        // Encryption Key      #3 (line below)
  DATA_B_ENCRYPTION_KEY = 2 [
    (string_name) = "display_value"
  ];
                                                        // Generic Password    #4 (line below)
  DATA_B_PASSWORD = 28970[
    (string_name) = "display_value"
  ];
                                                        // Generic Secret      #5 (line below)
  DATA_B_SECRET = 123456789[
    (string_name) = "display_value"
  ];
}

// Scenario 4 - Generic keywords in "reserved"
enum EnumAllowingAlias {
  reserved "password", "api_token", "private_key", "encryption_key", "exposed_secret";
  option end_of_sample = false;}enum InlineMessageFormat{option end_of_sample = true;}
```
</details>
<details><summary>Negative test num. 60 - tf file</summary>

```tf
# "Encryption Key"  - 9fb1cd65-7a07-4531-9bcf-47589d0f82d6 - "Avoiding TF resource access"  allow-rule-test - #1
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF variables"        allow-rule-test - #2
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding array access"        allow-rule-test - #3
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "encryption_key" {
  description = "Encryption key from external config"
  type        = string
  sensitive   = true
}


resource "aws_kms_key" "client_encryption_key" {
  for_each = { for k, v in var.clients.storage : k => v if var.enabled }

  description             = "KMS key for ${each.key}"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_kms_alias" "client_encryption_alias" {
  for_each = { for k, v in var.clients.storage : k => v if var.enabled }

  name          = "alias/${each.key}-encryption"
  target_key_id = aws_kms_key.client_encryption_key[each.key].key_id
}

module "storage" {
  for_each = { for k, v in var.clients.storage : k => v if var.enabled }
  source   = "./modules/storage"

  encryption_key = aws_kms_key.client_encryption_key[each.key].arn  #1
}

module "storage_2" {
  for_each = { for k, v in var.clients.storage : k => v if var.enabled }
  source   = "./modules/storage"

  encryption_key = aws_kms_key[each.key].client_encryption_key.arn  #1
}

module "storage_3" {
  for_each = { for k, v in var.clients.storage : k => v if var.enabled }
  source   = "./modules/storage"

  encryption_key = aws_kms_key["index"].client_encryption_key.arn   #3
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_enc" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.main[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = [for k in aws_kms_key.client_encryption_key : k.arn]  #1
    }
  }
}

module "optional_encryption" {
  source = "./modules/storage"

  encryption_key = null #1
}

module "database" {
  source = "./modules/database"

  encryption_key = var.encryption_key #2
}

module "app" {
  source = "./modules/app"

  encryption_key = module.encryption.key_output.value #1
}

data "aws_kms_key" "existing" {
  key_id = "alias/existing-encryption-key"
}

module "legacy" {
  source = "./modules/legacy"

  encryption_key = data.aws_kms_key.existing.arn  #1
}

locals {
  encryption_config = {
    key_arn = aws_kms_key.client_encryption_key["primary"].arn
  }
}

module "monitoring" {
  source = "./modules/monitoring"

  encryption_key = local.encryption_config.key_arn  #1
}
```
</details>
<details><summary>Negative test num. 61 - yaml file</summary>

```yaml
# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99 - "Avoiding CloudFormation Parameters Descriptions" allow rule test
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
      # negative1 :
      Description: 'Used to create resource-based authorization policy for "secretsmanager:GetSecretValue" action. E.g. All Athena JDBC Federation secret names can be prefixed with "AthenaJdbcFederation" and authorization policy will allow "arn:${AWS::Partition}:secretsmanager:${AWS::Region}:${AWS::AccountId}:secret:AthenaJdbcFederatione*". Parameter value in this case should be "AthenaJdbcFederation". If you do not have a prefix, you can manually update the IAM policy to add allow any secret names.'
      Type: String
Resources:
```
</details>
<details><summary>Negative test num. 62 - tf file</summary>

```tf
# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding TF creation token"  allow-rule-test
resource "aws_efs_file_system" "example" {
  creation_token = "my-efs-filesystem"  # negative1

  tags = {
    Name = "MyEFS"
  }
}

resource "aws_efs_file_system" "quoted_key" {
  creation_token = "my-efs-token-123"   # negative2
}
```
</details>
<details><summary>Negative test num. 63 - tf file</summary>

```tf
# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding LifecycleActionToken Var"  allow-rule-test
variable "lifecycle_config" {
  default = {
    LifecycleActionToken = "placeholder-token-value"
  }
}
```
</details>
<details><summary>Negative test num. 64 - json file</summary>

```json
{
  "metadata": "'Generic Token' - baee238e-1921-4801-9c3f-79ae1d7b2cbc - 'Avoiding LifecycleActionToken Var' allow-rule-test (line 13)",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Compute/virtualMachineScaleSets",
      "apiVersion": "2021-03-01",
      "name": "[parameters('vmssName')]",
      "location": "eastus",
      "properties": {
        "orchestrationMode": "Flexible",
        "lifecycleHook": {
          "LifecycleActionToken": "d290f1ee-6c54-4b01-90e6-d701748f0851",
          "LifecycleHookName": "my-lifecycle-hook",
          "AutoScalingGroupName": "my-asg-group",
          "LifecycleTransition": "autoscaling:EC2_INSTANCE_LAUNCHING"
        }
      }
    }
  ]
}
```
</details>
<details><summary>Negative test num. 65 - yaml file</summary>

```yaml
# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding LifecycleActionToken Var"  allow-rule-test (line 10)
Resources:
  LifecycleHookAction:
    Type: AWS::AutoScaling::LifecycleHook
    Properties:
      AutoScalingGroupName: my-asg-group
      LifecycleTransition: "autoscaling:EC2_INSTANCE_LAUNCHING"
      NotificationMetadata: |
        {
          "LifecycleActionToken": "d290f1ee-6c54-4b01-90e6-d701748f0851",
          "LifecycleHookName": "my-lifecycle-hook"
        }
```
</details>
<details><summary>Negative test num. 66 - yaml file</summary>

```yaml
# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding result_token Var"  allow-rule-test (line 13)
Resources:
  ConfigEvaluatorFunction:
    Type: AWS::Lambda::Function
    Properties:
      Runtime: python3.12
      Handler: index.handler
      Code:
        ZipFile: |
          import boto3
          config = boto3.client('config')
          def handler(event, context):
              result_token = event['resultToken']
              config.put_evaluations(
                  Evaluations=[{
                      'ComplianceResourceType': event['configRuleArn'],
                      'ComplianceResourceId': event['resourceId'],
                      'ComplianceType': 'COMPLIANT',
                      'OrderingTimestamp': event['notificationCreationTime']
                  }],
                  ResultToken=result_token
              )
```
</details>
<details><summary>Negative test num. 67 - tf file</summary>

```tf
# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding next_token Var"  allow-rule-test (line 21)
resource "aws_lambda_function" "list_resources" {
  function_name = "list-all-resources"
  runtime       = "python3.12"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "lambda.zip"
}

resource "local_file" "lambda_code" {
  filename = "index.py"
  content  = <<EOF
import boto3
ec2 = boto3.client('ec2')
def handler(event, context):
    next_token = event.get('NextToken', None)
    params = {'MaxResults': 100}
    if next_token:
        params['NextToken'] = next_token
    response = ec2.describe_instances(**params)
    return {'NextToken': response.get('NextToken')}
EOF
}
```
</details>
<details><summary>Negative test num. 68 - tf file</summary>

```tf
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - negative-test (empty string)
resource "google_container_cluster" "primary3" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = "1234567890qwertyuiopasdfghjklçzxcvbnm"
    password = ""   # negative1

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
<details><summary>Negative test num. 69 - yaml file</summary>

```yaml
# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99 - "Avoiding Secrets from Variable Interpolation"  allow-rule-test
AWSTemplateFormatVersion: '2010-09-09'
Description: CloudFormation template using dynamic references

Resources:
  MyRDSInstance:
    Type: AWS::RDS::DBInstance
    Properties:
      DBInstanceClass: db.t3.micro
      Engine: mysql
      MasterUsername: '{{resolve:secretsmanager:prod/db/credentials:SecretString:username}}'
      MasterUserPassword: '{{resolve:secretsmanager:prod/db/credentials:SecretString:password}}'
      AllocatedStorage: 20

  MyLambdaFunction:
    Type: AWS::Lambda::Function
    Properties:
      FunctionName: my-function
      Runtime: python3.12
      Handler: index.handler
      Code:
        ZipFile: |
          def handler(event, context):
              return {'statusCode': 200}
      Environment:
        Variables:
          API_TOKEN: '{{resolve:ssm-secure:/prod/api/token}}'
          DB_PASSWORD: '{{resolve:ssm-secure:/prod/db/password}}'
          APP_SECRET: '{{resolve:ssm:/prod/app/config}}' # negative1
```
</details>
<details><summary>Negative test num. 70 - yaml file</summary>

```yaml
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding ansible-vault encrypted variables"  allow-rule-test
AWSTemplateFormatVersion: '2010-09-09'
Description: CloudFormation template using dynamic references

Resources:
  MyRDSInstance:
    Type: AWS::RDS::DBInstance
    Properties:
      db_password: !vault |       # negative1
        $ANSIBLE_VAULT;1.1;AES256
        3436396162306336
      api_token: !vault |         # negative2
        $ANSIBLE_VAULT;1.1;AES256
        7172737475767778
      secret_key: !vault |        # is not caught by current "Generic Secret" - future proffing test
        $ANSIBLE_VAULT;1.1;AES256
        6162636465666768
```
</details>
<details><summary>Negative test num. 71 - tf file</summary>

```tf
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding sha-hashed mysql native passwords" allow-rule-test
terraform {
  required_providers {
    mysql = {
      source  = "petoju/mysql"
      version = "~> 3.0"
    }
  }
}

provider "mysql" {
  endpoint = "db.example.com:3306"
  username = "admin"
}

resource "mysql_user" "app_user" {
  user               = "app_user"
  host               = "%"
  auth_plugin         = "mysql_native_password"
  plaintext_password  = "*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9" # negative1
}

resource "mysql_grant" "app_user_grant" {
  user       = mysql_user.app_user.user
  host       = mysql_user.app_user.host
  database   = "app_db"
  privileges = ["SELECT", "INSERT", "UPDATE", "DELETE"]
}
```
</details>
<details><summary>Negative test num. 72 - yaml file</summary>

```yaml
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding sha-hashed mysql native passwords" allow-rule-test
---
- name: Configure MySQL database users
  hosts: db_servers
  become: yes

  tasks:
    - name: Create application database user
      community.mysql.mysql_user:
        name: app_user
        host: '%'
        password: '*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9' # negative1
        encrypted: yes
        priv: 'app_db.*:SELECT,INSERT,UPDATE,DELETE'
        state: present

    - name: Create readonly database user
      community.mysql.mysql_user:
        name: readonly_user
        host: '10.0.0.%'
        password: '*2470C0C06DEE42FD1618BB99005ADCA2EC9D1E19' # negative2
        encrypted: yes
        priv: 'app_db.*:SELECT'
        state: present
```
</details>
<details><summary>Negative test num. 73 - yaml file</summary>

```yaml
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding CF resolve" allow-rule-test
AWSTemplateFormatVersion: '2010-09-09'
Description: Example showing ambiguous secretsmanager resolve syntax

Resources:
  MyDatabase:
    Type: AWS::RDS::DBInstance
    Properties:
      DBInstanceIdentifier: !Sub '${Environment}-myapp-db'
      DBInstanceClass: !Ref DBInstanceClass
      Engine: postgres
      EngineVersion: '15.4'
      MasterUserPassword: '{{resolve:secretsmanager:prod/db/creds:SecretString:password:number1:value}}'  # negative1
```
</details>
<details><summary>Negative test num. 74 - tf file</summary>

```tf
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - negative-test (empty string)
resource "google_container_cluster" "primary5" {
  name               = "marcellus-wallace-credential"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = "PRIVATE KEY_key"
    password = ""   # negative1

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
<details><summary>Negative test num. 75 - tf file</summary>

```tf
# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99 - negative-test (secret_(id) is not (key|value))
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

