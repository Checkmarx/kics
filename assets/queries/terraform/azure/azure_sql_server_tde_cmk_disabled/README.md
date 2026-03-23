# KICS Rule: SQL Server TDE Not Encrypted with CMK

## General Description

This KICS rule ensures that the **Transparent Data Encryption (TDE)** feature of Azure SQL Server is configured to use a **Customer-Managed Key (CMK)** stored in Azure Key Vault.

By default, Azure SQL encrypts data at rest using a service-managed key (Microsoft). Although this method provides baseline security, using CMK offers a superior level of control that is indispensable for meeting strict corporate security regulations. With CMK, the organization assumes full control over the key lifecycle, allowing rotation, access revocation, and usage auditing in a sovereign manner through Azure Key Vault.

## Rule Logic

The policy audits the Terraform configuration following these criteria:
1.  **Identification:** Locates all resources of type `azurerm_mssql_server`.
2.  **Linking:** Checks whether an independent resource of type `azurerm_mssql_server_transparent_data_encryption` exists linked to the server via the `server_id` attribute.
3.  **Key Validation:** Verifies that said resource has the `key_vault_key_id` attribute explicitly defined.
4.  **Alert:** If the encryption resource is not found or if the Key Vault key reference is missing, a finding is generated.

## Detected Failure Case

The following describes the scenario this policy will detect.

---

### Single Case: Use of Service-Managed Key (Default)

* **Description:** The SQL server is defined but the additional resource required to enable TDE encryption using customer keys is not added, maintaining Azure's default encryption.
* **Example of Problematic Terraform Code:**
    ```terraform
    resource "azurerm_mssql_server" "fail_server" {
      name                         = "insecure-sql-server"
      resource_group_name          = azurerm_resource_group.example.name
      location                     = azurerm_resource_group.example.location
      version                      = "12.0"
      administrator_login          = "sqladmin"
      administrator_password       = "P@ssword123!"

      # Missing azurerm_mssql_server_transparent_data_encryption resource
    }
    ```
* **Alert Location:** On the root `azurerm_mssql_server` resource.

## Involved Resources

* `azurerm_mssql_server`
* `azurerm_mssql_server_transparent_data_encryption`

## Solution

To mitigate this risk, create an `azurerm_mssql_server_transparent_data_encryption` resource, link it to the SQL server, and provide the Azure Key Vault key URI.

```terraform
resource "azurerm_mssql_server_transparent_data_encryption" "secure_tde" {
  server_id        = azurerm_mssql_server.example.id

  # SOLUTION: Use a customer-managed key
  key_vault_key_id = azurerm_key_vault_key.example.id
}
