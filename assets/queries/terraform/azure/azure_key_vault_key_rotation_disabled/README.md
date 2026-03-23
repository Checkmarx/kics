# KICS Rule: Key Vault Key Rotation Disabled

## General Description

This KICS rule verifies that cryptographic keys stored in Azure Key Vault (`azurerm_key_vault_key`) have an automatic rotation policy configured.

Automatic key rotation is an essential security practice that limits the amount of data encrypted with a single key version and significantly reduces the impact if a key is compromised. Configuring a rotation policy ensures that keys are proactively renewed without manual intervention, guaranteeing operational continuity and compliance with security standards such as PCI-DSS or HIPAA.

## Rule Logic

The policy analyzes the `azurerm_key_vault_key` resource by performing the following steps:
1.  **Key Identification:** Selects all resources of type `azurerm_key_vault_key`.
2.  **Policy Verification:** Checks for the existence of the `rotation_policy` configuration block.
3.  **Alert Generation:** If the block is absent, the key is considered to have no defined rotation strategy and a finding is generated.

## Detected Failure Case

The following describes the scenario this policy will detect.

---

### Single Case: Key without Rotation Policy

* **Description:** A cryptographic key is defined in Key Vault but the `rotation_policy` block is omitted, leaving the rotation responsibility to manual processes or allowing the key to remain indefinitely.
* **Example of Problematic Terraform Code:**
    ```terraform
    resource "azurerm_key_vault_key" "fail_key" {
      name         = "example-key"
      key_vault_id = azurerm_key_vault.example.id
      key_type     = "RSA"
      key_size     = 2048
      key_opts     = ["decrypt", "encrypt", "sign", "verify"]

      # The resource lacks the rotation_policy configuration
    }
    ```
* **Alert Location:** On the root `azurerm_key_vault_key` resource.

## Involved Resource

* `azurerm_key_vault_key`

## Solution

To fix this risk, add the `rotation_policy` block defining the expiry time and the desired automatic rotation rules.

```terraform
resource "azurerm_key_vault_key" "secure_key" {
  name         = "example-key"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "verify"]

  # SOLUTION: Define automatic rotation policy
  rotation_policy {
    expire_after         = "P90D"
    notify_before_expiry = "P29D"

    automatic {
      time_before_expiry = "P30D"
    }
  }
}
