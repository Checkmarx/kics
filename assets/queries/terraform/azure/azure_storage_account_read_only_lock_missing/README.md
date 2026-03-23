# KICS Rule: Storage Account ReadOnly Lock Missing

## General Description

This KICS rule verifies that Azure storage accounts (`azurerm_storage_account`) have a **resource lock** (`azurerm_management_lock`) applied, specifically configured at the **`ReadOnly`** level.

Azure Resource Manager (ARM) locks provide an additional security layer that transcends RBAC permissions. Applying a `ReadOnly` type lock to a storage account ensures that the resource configuration (such as firewall rules, access tiers, or replication settings) cannot be modified or the resource accidentally deleted, even by administrators. It is an essential practice for critical data assets in production environments.

## Rule Logic

The policy performs a cross-analysis between storage account resources and defined locks:
1.  **Identification:** Locates all instances of `azurerm_storage_account`.
2.  **Linking:** Searches for `azurerm_management_lock` resources whose `scope` attribute references the Storage Account ID.
3.  **Level Validation:** Verifies that the `lock_level` attribute is strictly `"ReadOnly"`.
4.  **Finding Generation:** If the resource has no lock, or if existing locks have a lower level (such as `CanNotDelete`), an alert is generated.

## Detected Failure Cases

### Case 1: Storage Account Without a Lock

* **Description:** The storage account has been deployed without any management restriction, allowing accidental modifications.
* **Alert Location:** On the root `azurerm_storage_account` resource.

---

### Case 2: Lock With Incorrect Level

* **Description:** A lock associated with the resource exists, but its level is `"CanNotDelete"`, which allows modifications to the configuration that this rule seeks to restrict via `"ReadOnly"`.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_management_lock" "fail_lock" {
      name       = "prevent-deletion"
      scope      = azurerm_storage_account.example.id
      lock_level = "CanNotDelete" # <-- FAILURE: 'ReadOnly' is required
    }
    ```
* **Alert Location:** `lock_level` attribute of the lock resource.

## Involved Resources

* `azurerm_storage_account`
* `azurerm_management_lock`

## Solution

Add an `azurerm_management_lock` resource pointing to the storage account ID with the `ReadOnly` level.

```terraform
resource "azurerm_storage_account" "secure_sa" {
  name                     = "storage-prod-critical"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# SOLUTION: Apply ReadOnly lock
resource "azurerm_management_lock" "sa_readonly_lock" {
  name       = "critical-storage-lock"
  scope      = azurerm_storage_account.secure_sa.id
  lock_level = "ReadOnly"
  notes      = "Security lock for governance policy compliance"
}
