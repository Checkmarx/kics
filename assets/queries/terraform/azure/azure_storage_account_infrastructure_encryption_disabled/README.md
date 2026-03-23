# KICS Rule: Storage Account Infrastructure Encryption Disabled

## General Description

This KICS rule verifies that **Infrastructure Encryption** (`infrastructure_encryption_enabled`) is enabled on `azurerm_storage_account` resources.

By default, Azure Storage encrypts all data at rest using server-side encryption (SSE) with Microsoft-managed keys. However, enabling infrastructure encryption provides a defense-in-depth layer known as **Double Encryption**. In this model, data is encrypted twice: once at the storage service level and once at the underlying infrastructure level, using two independent encryption algorithms and distinct keys. This protects information even in the unlikely event that a single algorithm or key is compromised.

**Technical note:** This setting is **immutable**. It can only be enabled at the time of storage account creation; it cannot be activated afterwards without recreating the resource.

## Rule Logic

The policy audits the `azurerm_storage_account` resource by evaluating two scenarios:
1.  **Missing Attribute:** If `infrastructure_encryption_enabled` is not explicitly defined, KICS assumes the default value (`false`) and generates an alert on the resource.
2.  **Explicitly Disabled:** If the attribute is configured as `false`, an alert is generated indicating that double encryption protection is not active.

## Detected Failure Cases

The following describes the scenarios that this policy will detect.

---

### Case 1: Missing Double Encryption Configuration

* **Description:** The storage account is defined without including the infrastructure encryption parameter, delegating security solely to the default single encryption.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_storage_account" "fail_missing" {
      name                     = "storageinsecure"
      resource_group_name      = azurerm_resource_group.example.name
      location                 = azurerm_resource_group.example.location
      account_tier             = "Standard"
      account_replication_type = "LRS"
      # Missing infrastructure_encryption_enabled = true
    }
    ```
* **Alert Location:** On the root `azurerm_storage_account` resource.

---

### Case 2: Infrastructure Encryption Explicitly Disabled

* **Description:** The `infrastructure_encryption_enabled` attribute has been configured as `false`, disabling the required additional security layer.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_storage_account" "fail_explicit" {
      name                              = "storagedisabled"
      # ...
      infrastructure_encryption_enabled = false # <-- Detected issue
    }
    ```
* **Alert Location:** `infrastructure_encryption_enabled` attribute.

## Involved Resource

* `azurerm_storage_account`

## Solution

To mitigate this risk, set `infrastructure_encryption_enabled` to `true` during the initial definition of the storage account.

```terraform
resource "azurerm_storage_account" "secure_storage" {
  name                              = "storage-secure"
  resource_group_name               = azurerm_resource_group.example.name
  location                          = azurerm_resource_group.example.location
  account_tier                      = "Standard"
  account_replication_type          = "GRS"

  # SOLUTION: Enable infrastructure double encryption
  infrastructure_encryption_enabled = true
}
