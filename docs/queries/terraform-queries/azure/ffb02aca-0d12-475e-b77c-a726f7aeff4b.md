---
title: Log Retention Is Not Set
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

-   **Query id:** ffb02aca-0d12-475e-b77c-a726f7aeff4b
-   **Query name:** Log Retention Is Not Set
-   **Platform:** Terraform
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Observability
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/azure/log_retention_is_not_set)

### Description
Make sure that for PostgreSQL Database, server parameter 'log_retention' is set to 'ON'<br>
[Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_configuration)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="19 12 5"
resource "azurerm_postgresql_configuration" "positive1" {
    name                = "log_retention"
    resource_group_name = data.azurerm_resource_group.example.name
    server_name         = azurerm_postgresql_server.example.name
    value               = "off"
}

resource "azurerm_postgresql_configuration" "positive2" {
    name                = "log_retention"
    resource_group_name = data.azurerm_resource_group.example.name
    server_name         = azurerm_postgresql_server.example.name
    value               = "Off"
}

resource "azurerm_postgresql_configuration" "positive3" {
    name                = "log_retention"
    resource_group_name = data.azurerm_resource_group.example.name
    server_name         = azurerm_postgresql_server.example.name
    value               = "OFF"
}
```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
resource "azurerm_postgresql_configuration" "negative1" {
    name                = "log_retention"
    resource_group_name = data.azurerm_resource_group.example.name
    server_name         = azurerm_postgresql_server.example.name
    value               = "on"
}

resource "azurerm_postgresql_configuration" "negative2" {
    name                = "log_retention"
    resource_group_name = data.azurerm_resource_group.example.name
    server_name         = azurerm_postgresql_server.example.name
    value               = "On"
}

resource "azurerm_postgresql_configuration" "negative3" {
    name                = "log_retention"
    resource_group_name = data.azurerm_resource_group.example.name
    server_name         = azurerm_postgresql_server.example.name
    value               = "ON"
}
```
