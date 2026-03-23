# KICS Rule: Recovery Services Vault Infrastructure Encryption Disabled

## General Description

This KICS rule verifies that **Infrastructure Encryption** (`infrastructure_encryption_enabled`) is enabled in **Recovery Services Vault** vaults.

Infrastructure encryption provides an additional layer of protection through the use of a second encryption algorithm (**Double Encryption**). While all data in Azure is already encrypted at rest, enabling this option ensures that data is encrypted twice using two independent algorithms. This configuration is essential for organizations with highly strict compliance requirements seeking to mitigate risks against potential vulnerabilities in a single cryptographic standard.

## Rule Logic

The policy analyzes the `azurerm_recovery_services_vault` resource by validating two technical aspects:
1.  **Encryption Block:** Verifies the existence of the `encryption` block. If it does not exist, it is assumed that there is no double encryption.
2.  **Infrastructure Encryption:** Verifies that the `infrastructure_encryption_enabled` attribute is explicitly set to `true`.

## Detected Failure Cases

The following describes the scenarios that this policy will detect.

---

### Case 1: Missing Encryption Block

* **Description:** The vault does not have the `encryption` block defined, so it uses only Azure's default encryption without additional layers.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_recovery_services_vault" "fail_missing" {
      name                = "insecure-vault"
      resource_group_name = "rg-prod"
      location            = "West Europe"
      sku                 = "Standard"
      # Missing encryption {} block
    }
    ```
* **Alert Location:** On the root `azurerm_recovery_services_vault` resource.

---

### Case 2: Infrastructure Encryption Disabled

* **Description:** The `encryption` block exists but the `infrastructure_encryption_enabled` attribute is not configured or is set to `false`.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_recovery_services_vault" "fail_disabled" {
      name = "vault-vulnerable"
      # ...
      encryption {
        key_id                            = azurerm_key_vault_key.example.id
        infrastructure_encryption_enabled = false
        use_system_assigned_identity      = true
      }
    }
    ```
* **Alert Location:** `infrastructure_encryption_enabled` attribute.

## Involved Resource

* `azurerm_recovery_services_vault`

## Solution

To mitigate this risk, ensure you declare the `encryption` block setting `infrastructure_encryption_enabled` to `true`.

```terraform
resource "azurerm_recovery_services_vault" "secure_vault" {
  name                = "secure-recovery-vault"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Standard"

  identity {
    type = "SystemAssigned"
  }

  encryption {
    key_id                            = azurerm_key_vault_key.example.id
    infrastructure_encryption_enabled = true
    use_system_assigned_identity      = true
  }
}
