# KICS Rule: Critical Data Storage CMK (Manual)

## General Description

This rule identifies Azure storage accounts (`azurerm_storage_account`) that use Microsoft-managed encryption (**Platform-Managed Keys**).

Encryption at rest is automatic in Azure, but using platform-managed keys is not always sufficient to comply with data sovereignty regulations or critical data security requirements. This rule acts as a **manual audit** control: it identifies resources without **Customer-Managed Keys (CMK)** so that the security team can validate whether the contained data (financial, PII, trade secrets) requires the organization to own and manage the encryption keys in their own Key Vault.

## Rule Logic

The policy audits the `azurerm_storage_account` resource by evaluating two scenarios:
1.  **Missing CMK Configuration:** If the `customer_managed_key` block is not present, the account uses Azure's default keys.
2.  **Incomplete Configuration:** If the `customer_managed_key` block exists but does not define the `key_vault_key_id` attribute, CMK encryption is not being effectively applied.

## Detected Failure Cases

### Case 1: Data Sensitivity Review Required (Default Encryption)

* **Description:** The account uses Azure's base encryption. Manual validation is required to determine whether data criticality warrants a move to CMK.
* **Alert Location:** `azurerm_storage_account` resource.

### Case 2: CMK Block Without Associated Key

* **Description:** The customer-managed key block has been declared but the cryptographic key identifier has been omitted.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_storage_account" "fail_incomplete" {
      name = "stincomplete"
      # ...
      customer_managed_key {
        user_assigned_identity_id = azurerm_user_assigned_identity.example.id
        # key_vault_key_id is optional in the schema but required for CMK
      }
    }
    ```
* **Alert Location:** `customer_managed_key` block.

## Involved Resource

* `azurerm_storage_account`

## Solution

If the manual review confirms that the data is critical, implement CMK by linking an Azure Key Vault key.

```terraform
resource "azurerm_storage_account" "secure_critical" {
  name                     = "stcriticaldata"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  identity {
    type = "SystemAssigned"
  }

  customer_managed_key {
    # SOLUTION: Explicitly define the Key Vault key
    key_vault_key_id = azurerm_key_vault_key.example.id
  }
}
