---
title: Sensitive Port Is Exposed To Entire Network
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

-   **Query id:** 0ac9abbc-6d7a-41cf-af23-2e57ddb3dbfc
-   **Query name:** Sensitive Port Is Exposed To Entire Network
-   **Platform:** Ansible
-   **Severity:** <span style="color:#bb2124">High</span>
-   **Category:** Networking and Firewall
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/200.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/200.html')">200</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/ansible/azure/sensitive_port_is_exposed_to_entire_network)

### Description
A sensitive port, such as port 23 or port 110, is open for the whole network in either TCP or UDP protocol<br>
[Documentation](https://docs.ansible.com/ansible/latest/collections/azure/azcollection/azure_rm_securitygroup_module.html#parameter-rules)

### Code samples
#### Code samples with security vulnerabilities
```yaml title="Positive test num. 1 - yaml file" hl_lines="130 99 69 41 13 142 113 85 55 27"
---
- name: foo1
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
      - name: example1
        priority: 100
        direction: Inbound
        access: Allow
        protocol: UDP
        source_port_range: "*"
        destination_port_range: "61621"
        source_address_prefix: "/0"
        destination_address_prefix: "*"
- name: foo2
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
      - name: example2
        priority: 100
        direction: Inbound
        access: Allow
        protocol: TCP
        source_port_range: "*"
        destination_port_range: "23-34"
        source_address_prefix: "1.1.1.1/0"
        destination_address_prefix: "*"
- name: foo3
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
      - name: example3
        priority: 100
        direction: Inbound
        access: Allow
        protocol: "*"
        source_port_range: "*"
        destination_port_range: "21-23"
        source_address_prefix: "/0"
        destination_address_prefix: "*"
- name: foo4
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
      - name: example4
        priority: 100
        direction: Inbound
        access: Allow
        protocol: "*"
        source_port_range: "*"
        destination_port_range: "23"
        source_address_prefix: "0.0.0.0/0"
        destination_address_prefix: "*"
- name: foo5
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
      - name: example5
        priority: 100
        direction: Inbound
        access: Allow
        protocol: "UDP"
        source_port_range: "*"
        destination_port_range:
          - "23"
          - "245"
        source_address_prefix: "34.15.11.3/0"
        destination_address_prefix: "*"
- name: foo6
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
      - name: example6
        priority: 100
        direction: Inbound
        access: Allow
        protocol: "TCP"
        source_port_range: "*"
        destination_port_range: "23"
        source_address_prefix: "/0"
        destination_address_prefix: "*"
- name: foo7
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
      - name: example7
        priority: 100
        direction: Inbound
        access: Allow
        protocol: "UDP"
        source_port_range: "*"
        destination_port_range: "22-64, 94"
        source_address_prefix: "10.0.0.0/0"
        destination_address_prefix: "*"
- name: foo8
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
      - name: example8
        priority: 100
        direction: Inbound
        access: Allow
        protocol: "TCP"
        source_port_range: "*"
        destination_port_range:
          - "14"
          - "23"
          - "48"
        source_address_prefix: "12.12.12.12/0"
        destination_address_prefix: "*"
- name: foo9
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
      - name: example9
        priority: 100
        direction: Inbound
        access: Allow
        protocol: "*"
        source_port_range: "*"
        destination_port_range:
          - "12"
          - "23-24"
          - "46"
        source_address_prefix: "/0"
        destination_address_prefix: "*"
      - name: example10
        priority: 100
        direction: Inbound
        access: Allow
        protocol: "*"
        source_port_range: "*"
        destination_port_range: 46-146, 18-36, 1-2, 3
        source_address_prefix: "1.2.3.4/0"
        destination_address_prefix: "*"

```


#### Code samples without security vulnerabilities
```yaml title="Negative test num. 1 - yaml file"
- name: foo1
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
    - name: example1
      priority: 100
      direction: Inbound
      access: Deny
      protocol: TCP
      source_port_range: '*'
      destination_port_range: 23
      source_address_prefix: '*'
      destination_address_prefix: '*'
- name: foo2
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
    - name: example2
      priority: 100
      direction: Inbound
      access: Allow
      protocol: Icmp
      source_port_range: '*'
      destination_port_range: 23-24
      source_address_prefix: '*'
      destination_address_prefix: '*'
- name: foo3
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
    - name: example3
      priority: 100
      direction: Inbound
      access: Allow
      protocol: TCP
      source_port_range: '*'
      destination_port_range: 8-174
      source_address_prefix: 0.0.0.0
      destination_address_prefix: '*'
- name: foo4
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
    - name: example4
      priority: 100
      direction: Inbound
      access: Allow
      protocol: TCP
      source_port_range: '*'
      destination_port_range: 23-196
      source_address_prefix: 192.168.0.0
      destination_address_prefix: '*'
- name: foo5
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
    - name: example5
      priority: 100
      direction: Inbound
      access: Allow
      protocol: TCP
      source_port_range: '*'
      destination_port_range: 23
      source_address_prefix: /1
      destination_address_prefix: '*'
- name: foo6
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
    - name: example6
      priority: 100
      direction: Inbound
      access: Allow
      protocol: '*'
      source_port_range: '*'
      destination_port_range: 43
      source_address_prefix: /0
      destination_address_prefix: '*'
- name: foo7
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
    - name: example7
      priority: 100
      direction: Inbound
      access: Allow
      protocol: Icmp
      source_port_range: '*'
      destination_port_range: 23
      source_address_prefix: internet
      destination_address_prefix: '*'
- name: foo8
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
    - name: example8
      priority: 100
      direction: Inbound
      access: Allow
      protocol: '*'
      source_port_range: '*'
      destination_port_range: 22, 24,49-67
      source_address_prefix: any
      destination_address_prefix: '*'
- name: foo9
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
    - name: example9
      priority: 100
      direction: Inbound
      access: Allow
      protocol: Icmp
      source_port_range: '*'
      destination_port_range: 23
      source_address_prefix: /0
      destination_address_prefix: '*'
- name: foo10
  azure_rm_securitygroup:
    resource_group: myResourceGroup
    name: mysecgroup
    rules:
    - name: example10
      priority: 100
      direction: Inbound
      access: Allow
      protocol: TCP
      source_port_range: '*'
      destination_port_range:
      - 23
      - 69
      source_address_prefix: 0.0.1.0
      destination_address_prefix: '*'
    - name: example11
      priority: 100
      direction: Inbound
      access: Allow
      protocol: TCP
      source_port_range: '*'
      destination_port_range:
      - 2
      - 310
      source_address_prefix: 0.0.0.0
      destination_address_prefix: '*'

```
