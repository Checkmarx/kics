# KICS Rule: NetApp Account CMK Encryption Disabled

## General Description

This KICS rule verifies that **Azure NetApp Files** accounts are configured to use **Customer-Managed Keys (CMK)** for data encryption at rest.

By default, Azure NetApp Files encrypts data using Microsoft platform-managed keys. However, to meet regulatory compliance and data sovereignty requirements, the use of CMK is recommended. This allows organizations to have full control over the key lifecycle, including rotation and access revocation, ensuring that high-performance storage volumes are protected by keys under the direct control of the customer in Azure Key Vault.

## Rule Logic

The policy analyzes the Terraform configuration looking for two valid CMK implementation methods:
1.  **Inline Configuration:** Checks whether the `azurerm_netapp_account` resource has an `encryption` block where the `key_source` attribute is explicitly `Microsoft.KeyVault`.
2.  **Standalone Resource:** Checks whether an `azurerm_netapp_account_encryption` resource exists linked to the analyzed NetApp account's ID.

If neither of these two methods is detected, an alert is generated indicating that the account is operating with the platform's default encryption.

## Detected Failure Case

The following describes the scenario this policy will detect.

---

### Single Case: Default Encryption Configuration (Platform Keys)

* **Description:** The NetApp account is defined without enabling Key Vault for encryption, leaving the data protected only by Microsoft keys.
* **Example of Problematic Terraform Code:**
    ```terraform
    resource "azurerm_netapp_account" "fail" {
      name                = "insecure-netapp-account"
      resource_group_name = azurerm_resource_group.example.name
      location            = azurerm_resource_group.example.location

      # Missing CMK configuration (inline or separate resource)
    }
    ```
* **Alert Location:** On the root `azurerm_netapp_account` resource.

## Involved Resources

* `azurerm_netapp_account`
* `azurerm_netapp_account_encryption`

## Solution

To fix this risk, assign a managed identity to the account and use the `azurerm_netapp_account_encryption` resource to link the Key Vault key.

```terraform
resource "azurerm_netapp_account" "secure" {
  name                = "secure-netapp-account"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  # 1. Assign identity
  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.example.id]
  }
}

# 2. Configure CMK encryption via the dedicated resource
resource "azurerm_netapp_account_encryption" "secure_encryption" {
  netapp_account_id         = azurerm_netapp_account.secure.id
  user_assigned_identity_id = azurerm_user_assigned_identity.example.id
  encryption_key            = azurerm_key_vault_key.example.versionless_id
}
