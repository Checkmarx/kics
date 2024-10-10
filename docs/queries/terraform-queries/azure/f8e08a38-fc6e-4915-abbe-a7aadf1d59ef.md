---
title: Key Vault Secrets Content Type Undefined
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

-   **Query id:** f8e08a38-fc6e-4915-abbe-a7aadf1d59ef
-   **Query name:** Key Vault Secrets Content Type Undefined
-   **Platform:** Terraform
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Best Practices
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/665.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/665.html')">665</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/azure/key_vault_secrets_content_type_undefined)

### Description
Key Vault Secrets should have set Content Type<br>
[Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret#content_type)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="1"
resource "azurerm_key_vault_secret" "positive" {
  name         = "secret-sauce"
  value        = "szechuan"
  key_vault_id = azurerm_key_vault.example.id
}

```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
resource "azurerm_key_vault_secret" "negative" {
  name         = "secret-sauce"
  value        = "szechuan"
  key_vault_id = azurerm_key_vault.example.id
  content_type = "password"
}

```
