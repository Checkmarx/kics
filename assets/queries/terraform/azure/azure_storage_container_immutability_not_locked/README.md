# KICS Rule: Storage Immutability Policy Not Locked

## General Description

This rule verifies that immutability policies (`azurerm_storage_container_immutability_policy`) applied to Azure Storage containers are configured in the **Locked** state (`locked = true`).

Immutability policies allow data to be stored in a **WORM** (Write Once, Read Many) format. In the context of access control and data protection, there are two critical states:
* **Unlocked (Mutable):** The policy protects data against deletion or modification, but the policy itself can be deleted or modified by users with high privileges. It is a transient state and does not guarantee long-term immutability.
* **Locked (Immutable):** Once locked, the policy becomes irreversible; it cannot be deleted and the retention period can only be increased. This state is a strict integrity control that ensures that not even an administrator can delete data ahead of time.

## Rule Logic

The rule audits `azurerm_storage_container_immutability_policy` resources by evaluating two control conditions:
1.  **Attribute Omission:** If the `locked` attribute is not defined, Azure assumes the "Unlocked" state by default, allowing the protection to be removed.
2.  **Incorrect Value:** If the `locked` attribute is explicitly set to `false`.

## Detected Failure Cases

### Case 1: Missing Lock Attribute

* **Description:** A retention policy is defined but it is not specified whether it should be locked. By default, Azure creates it in the "Unlocked" state.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_storage_container_immutability_policy" "fail_missing" {
      storage_container_resource_manager_id = azurerm_storage_container.example.id
      retention_period_in_days              = 365
      # Missing locked = true
    }
    ```
* **Alert Location:** On the root `azurerm_storage_container_immutability_policy` resource.

---

### Case 2: Mutable Policy (Unlocked)

* **Description:** The `locked` attribute is explicitly set to `false`, which allows the immutability policy to be deleted by authorized users.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_storage_container_immutability_policy" "fail_explicit" {
      storage_container_resource_manager_id = azurerm_storage_container.example.id
      retention_period_in_days              = 730
      locked                                = false # <-- DETECTED ISSUE
    }
    ```
* **Alert Location:** `locked` attribute.

## Involved Resource

* `azurerm_storage_container_immutability_policy`

## Solution

Set the `locked` attribute to `true` to ensure that the data integrity control is permanent and meets WORM requirements.

> [!WARNING]
> **Critical Warning:** Once a policy is locked in Azure, **it cannot be deleted**. You will only be able to delete the container once the retention period of all objects has expired. Carefully validate the retention days before applying this change in production.

```terraform
resource "azurerm_storage_container_immutability_policy" "secure_policy" {
  storage_container_resource_manager_id = azurerm_storage_container.example.id
  retention_period_in_days              = 365

  # SOLUTION: Policy lock enabled for WORM integrity
  locked                                = true
}
