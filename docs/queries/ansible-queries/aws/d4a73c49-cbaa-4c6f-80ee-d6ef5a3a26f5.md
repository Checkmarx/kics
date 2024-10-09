---
title: CloudTrail Logging Disabled
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

-   **Query id:** d4a73c49-cbaa-4c6f-80ee-d6ef5a3a26f5
-   **Query name:** CloudTrail Logging Disabled
-   **Platform:** Ansible
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Observability
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/778.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/778.html')">778</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/ansible/aws/cloudtrail_logging_disabled)

### Description
Checks if logging is enabled for CloudTrail.<br>
[Documentation](https://docs.ansible.com/ansible/latest/collections/community/aws/cloudtrail_module.html#parameter-enable_logging)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="5"
- name: example
  community.aws.cloudtrail:
    state: present
    name: default
    enable_logging: false

```


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
- name: example
  community.aws.cloudtrail:
    state: present
    name: default
    enable_logging: true

```
