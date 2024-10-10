---
title: PostgreSQL Server Without Connection Throttling
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

-   **Query id:** a9becca7-892a-4af7-b9e1-44bf20a4cd9a
-   **Query name:** PostgreSQL Server Without Connection Throttling
-   **Platform:** Ansible
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Observability
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/770.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/770.html')">770</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/ansible/azure/postgresql_server_without_connection_throttling)

### Description
Ensure that Connection Throttling is set for the PostgreSQL server<br>
[Documentation](https://docs.ansible.com/ansible/latest/collections/azure/azcollection/azure_rm_postgresqlconfiguration_module.html)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="37 7 13 19 25 31"
---
- name: Update PostgreSQL Server setting
  azure.azcollection.azure_rm_postgresqlconfiguration:
    resource_group: myResourceGroup
    server_name: myServer
    name: connection_throttling
    value: off
- name: Update PostgreSQL Server setting2
  azure.azcollection.azure_rm_postgresqlconfiguration:
    resource_group: myResourceGroup
    server_name: myServer
    name: connection_throttling
    value: Off
- name: Update PostgreSQL Server setting3
  azure.azcollection.azure_rm_postgresqlconfiguration:
    resource_group: myResourceGroup
    server_name: myServer
    name: connection_throttling
    value: OFF
- name: Update PostgreSQL Server setting4
  azure.azcollection.azure_rm_postgresqlconfiguration:
    resource_group: myResourceGroup
    server_name: myServer
    name: connection_throttling
    value: "off"
- name: Update PostgreSQL Server setting5
  azure.azcollection.azure_rm_postgresqlconfiguration:
    resource_group: myResourceGroup
    server_name: myServer
    name: connection_throttling
    value: "Off"
- name: Update PostgreSQL Server setting6
  azure.azcollection.azure_rm_postgresqlconfiguration:
    resource_group: myResourceGroup
    server_name: myServer
    name: connection_throttling
    value: "OFF"

```


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
- name: Update PostgreSQL Server setting
  azure.azcollection.azure_rm_postgresqlconfiguration:
    resource_group: myResourceGroup
    server_name: myServer
    name: connection_throttling
    value: on
- name: Update PostgreSQL Server setting2
  azure.azcollection.azure_rm_postgresqlconfiguration:
    resource_group: myResourceGroup
    server_name: myServer
    name: connection_throttling
    value: On
- name: Update PostgreSQL Server setting3
  azure.azcollection.azure_rm_postgresqlconfiguration:
    resource_group: myResourceGroup
    server_name: myServer
    name: connection_throttling
    value: ON
- name: Update PostgreSQL Server setting4
  azure.azcollection.azure_rm_postgresqlconfiguration:
    resource_group: myResourceGroup
    server_name: myServer
    name: connection_throttling
    value: on
- name: Update PostgreSQL Server setting5
  azure.azcollection.azure_rm_postgresqlconfiguration:
    resource_group: myResourceGroup
    server_name: myServer
    name: connection_throttling
    value: On
- name: Update PostgreSQL Server setting6
  azure.azcollection.azure_rm_postgresqlconfiguration:
    resource_group: myResourceGroup
    server_name: myServer
    name: connection_throttling
    value: ON

```
