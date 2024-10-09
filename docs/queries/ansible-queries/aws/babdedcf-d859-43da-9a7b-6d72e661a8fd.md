---
title: IAM Role Allows All Principals To Assume
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

-   **Query id:** babdedcf-d859-43da-9a7b-6d72e661a8fd
-   **Query name:** IAM Role Allows All Principals To Assume
-   **Platform:** Ansible
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Access Control
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/284.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/284.html')">284</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/ansible/aws/iam_role_allows_all_principals_to_assume)

### Description
IAM role allows all services or principals to assume it<br>
[Documentation](https://docs.ansible.com/ansible/latest/collections/community/aws/iam_managed_policy_module.html)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="17 4"
- name: Create IAM Managed Policy
  community.aws.iam_managed_policy:
    policy_name: "ManagedPolicy"
    policy:
      Version: "2012-10-17"
      Statement:
      - Effect: "Allow"
        Action: "logs:CreateLogGroup"
        Resource: "*"
        Principal:
          AWS: "arn:aws:iam::root"
    make_default: false
    state: present
- name: Create2 IAM Managed Policy
  community.aws.iam_managed_policy:
    policy_name: "ManagedPolicy2"
    policy: >
      {
        "Version": "2012-10-17",
        "Statement":[{
          "Effect": "Allow",
          "Action": "logs:PutRetentionPolicy",
          "Resource": "*",
          "Principal" : { "AWS" : "arn:aws:iam::root" }
        }]
      }
    only_version: true
    state: present

```


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
- name: Create IAM Managed Policy
  community.aws.iam_managed_policy:
    policy_name: ManagedPolicy
    policy:
      Version: '2012-10-17'
      Statement:
      - Effect: Allow
        Action: logs:CreateLogGroup
        Resource: '*'
    make_default: false
    state: present

```
