---
title: Serverless Role With Full Privileges
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

-   **Query id:** 59ebb4f3-2a6c-46dc-b4f0-cc5418dcddcd
-   **Query name:** Serverless Role With Full Privileges
-   **Platform:** ServerlessFW
-   **Severity:** <span style="color:#bb2124">High</span>
-   **Category:** Access Control
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/732.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/732.html')">732</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/serverlessFW/serverless_role_with_full_privileges)

### Description
Roles defined in Serverless files should not have policies granting full administrative privileges.<br>
[Documentation](https://www.serverless.com/framework/docs/providers/aws/guide/iam)

### Code samples
#### Code samples with security vulnerabilities
```yml title="Positive test num. 1 - yml file" hl_lines="11"
service: service
frameworkVersion: '2' 
provider:
  name: aws
  runtime: nodejs12.x
  iam:
    role:
      name: custom-role-name
      path: /custom-role-path/
      statements:
        - Effect: 'Allow'
          Resource: '*'
          Action: '*'
      managedPolicies:
        - 'arn:aws:iam::123456789012:user/*'
      permissionsBoundary: arn:aws:iam::123456789012:policy/boundaries
      tags:
        key: value
 
functions:
  hello:
    handler: handler.hello
    onError: arn:aws:sns:us-east-1:XXXXXX:test
    tags:
      foo: bar
    role: arn:aws:iam::XXXXXX:role/role
    tracing: Active

```


#### Code samples without security vulnerabilities
```yml title="Negative test num. 1 - yml file"
service: service
frameworkVersion: '2' 
provider:
  name: aws
  runtime: nodejs12.x
  iam:
    role:
      name: custom-role-name
      path: /custom-role-path/
      statements:
        - Effect: 'Allow'
          Resource: '*'
          Action: 'iam:DeleteUser'
      managedPolicies:
        - 'arn:aws:iam::123456789012:user/*'
      permissionsBoundary: arn:aws:iam::123456789012:policy/boundaries
      tags:
        key: value
 
functions:
  hello:
    handler: handler.hello
    onError: arn:aws:sns:us-east-1:XXXXXX:test
    tags:
      foo: bar
    role: arn:aws:iam::XXXXXX:role/role
    tracing: Active

```
