# KICS Rule: Storage Account Blob Versioning Disabled

## General Description

This rule verifies that the **Versioning** feature (version control) is enabled on `azurerm_storage_account` resources.

Blob versioning allows automatically maintaining previous versions of an object when it is modified or deleted. It is a fundamental protection layer for data recovery scenarios involving human errors, accidental overwrites, or ransomware attacks, allowing restoration of a previous state of the file without needing to resort to complex external backups.

## Rule Logic

The policy evaluates the configuration at three levels of granularity:
1.  **Missing Block:** If the resource does not have the `blob_properties` block defined.
2.  **Missing Attribute:** If the block exists but the `versioning_enabled` parameter is not defined.
3.  **Incorrect Value:** If `versioning_enabled` has been explicitly configured as `false`.

## Detected Failure Cases

The following describes the scenarios that this policy will detect.

---

### Case 1: Missing Block Configuration

* **Description:** The resource does not define the `blob_properties` block. By default, Azure disables versioning if not specified.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_storage_account" "fail_1" {
      name                     = "storage-insecure-1"
      resource_group_name      = "rg-prod"
      location                 = "West Europe"
      account_tier             = "Standard"
      account_replication_type = "LRS"

      # The blob_properties block is missing
    }
    ```
* **Alert Location:** On the root `azurerm_storage_account` resource.

---

### Case 2: Versioning Explicitly Disabled

* **Description:** The properties block is included but versioning is turned off, which prevents recovery of modified files.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_storage_account" "fail_2" {
      name                = "storage-insecure-2"
      # ...
      blob_properties {
        versioning_enabled = false  # <-- ISSUE: Disabled.
      }
    }
    ```
* **Alert Location:** Line `versioning_enabled = false`.

## Involved Resource

* `azurerm_storage_account`

## Solution

To resolve this risk, ensure you include the `blob_properties` block with the `versioning_enabled` attribute set to `true`.

```terraform
resource "azurerm_storage_account" "secure_storage" {
  name                     = "storage-secure"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  # SOLUTION: Enable blob versioning
  blob_properties {
    versioning_enabled = true
  }
}
