# KICS Rule: Storage Queue Service Logging Disabled

## General Description

This rule verifies that **Storage Logging** (Storage Analytics Logging) is enabled for the **Queue Service** in Azure storage accounts.

Audit logging is a fundamental component of observability. It allows detailed activity in the data plane to be tracked, capturing who and when interacted with queue messages. The policy validates that the following operations are recorded:
* **Read:** Operations such as viewing or extracting messages.
* **Write:** Message insertion or update operations.
* **Delete:** Message deletion or queue purge operations.

Without this configuration, organizations lose the traceability needed to investigate anomalous behavior or information leaks through the messaging service.

## Rule Logic

The policy audits both the configuration embedded in the storage account and the specific properties resource:
1.  **Attribute Identification:** Looks for the presence of `queue_properties` in the main resource or instances of the standalone resource.
2.  **Audit Validation:** Ensures the existence of the `logging` block.
3.  **Action Verification:** Checks that `read`, `write`, and `delete` are explicitly configured as `true`.

## Detected Failure Cases

The following describes the scenarios that this policy will detect.

---

### Case 1: Missing Embedded Logging

* **Description:** Queue properties are defined in the storage account but the logging configuration is not included.
* **Alert Location:** `queue_properties` block of the `azurerm_storage_account` resource.

---

### Case 2: Incorrect Embedded Configuration

* **Description:** The logging block exists in the storage account but one of the critical actions is disabled.
* **Problematic Terraform Code Example:**
    ```terraform
    resource "azurerm_storage_account" "fail_logging" {
      # ...
      queue_properties {
        logging {
          read  = false # <-- ISSUE
          write = true
          delete = true
          version = "1.0"
        }
      }
    }
    ```
* **Alert Location:** `logging` attribute of the `azurerm_storage_account` resource.

---

### Case 3: Standalone Resource Without Logging

* **Description:** The `azurerm_storage_account_queue_properties` resource is used but the logging block is completely omitted.
* **Alert Location:** `azurerm_storage_account_queue_properties` resource.

---

### Case 4: Standalone Resource With Incorrect Configuration

* **Description:** The standalone properties resource has the logging block, but with disabled actions.
* **Alert Location:** `logging` attribute of the `azurerm_storage_account_queue_properties` resource.

## Involved Resources

* `azurerm_storage_account`
* `azurerm_storage_account_queue_properties`

## Solution

Enable logging for all operations (`read`, `write`, `delete`) within the queue service configuration.

```terraform
resource "azurerm_storage_account" "secure_queue" {
  name                     = "stsecurequeue"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  queue_properties {
    logging {
      read                  = true
      write                 = true
      delete                = true
      version               = "1.0"
      retention_policy_days = 30
    }
  }
}
