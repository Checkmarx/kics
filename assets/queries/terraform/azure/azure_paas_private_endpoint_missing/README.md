# KICS Rule: Azure PaaS Services Private Endpoint Disabled (Master)

## General Description

This is a consolidated rule (**Master Rule**) designed to ensure that critical Azure PaaS services are protected through the use of **Private Endpoints**.

Private Endpoints are an essential component of perimeter security in Azure. They allow services (such as databases, storage, or key vaults) to integrate directly into a Virtual Network (VNet). By assigning a private IP address from the VNet's address space to the service, the need to expose those resources to the public internet is eliminated, drastically reducing the attack surface and preventing data exfiltration.

## Rule Logic

The policy comprehensively analyzes resources defined in Terraform looking for a valid link:
1.  **Target Resources:** The rule monitors an extensive list of services, including `azurerm_storage_account`, `azurerm_mssql_server`, `azurerm_cosmosdb_account`, `azurerm_key_vault`, and other data and messaging services.
2.  **Link Validation:** For each detected resource, it looks for the existence of an `azurerm_private_endpoint` resource that references it through the `private_connection_resource_id` attribute.
3.  **Result:** If the PaaS resource exists but there is no associated private endpoint in the same code context, an alert is generated.

## Static Analysis Limitations

It is important to note that this rule validates the configuration **within the same Terraform file or state**. Due to the nature of static analysis:
* It cannot validate connections if the resource is created in a different subscription or managed in a separate Terraform state.
* It may generate false positives if the endpoint is defined through external modules whose variables are not resolved by the scanning engine.

## Detected Failure Case

The following describes the main scenario this policy will detect.

---

### Single Case: Isolated PaaS Resource (No Private Endpoint)

* **Description:** A critical service (e.g., Azure SQL or Storage Account) has been defined but the private endpoint that ensures traffic is internal to the VNet has not been provisioned.
* **Example of Problematic Terraform Code:**
    ```terraform
    resource "azurerm_storage_account" "example_insecure" {
      name                     = "stinsecuredata"
      resource_group_name      = azurerm_resource_group.example.name
      location                 = azurerm_resource_group.example.location
      account_tier             = "Standard"
      account_replication_type = "LRS"

      # The resource exists but lacks a linked azurerm_private_endpoint
    }
    ```
* **Alert Location:** On the identified PaaS resource (Storage, SQL, Key Vault, etc.).

## Involved Resources

* `azurerm_private_endpoint`
* PaaS Services (Storage, SQL, Cosmos, KeyVault, ACR, ServiceBus, etc.)

## Solution

To fix this finding, you must create an `azurerm_private_endpoint` resource and link it to the PaaS resource ID via the `private_service_connection` block.

```terraform
resource "azurerm_private_endpoint" "example_secure" {
  name                = "pe-storage"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "psc-storage"
    private_connection_resource_id = azurerm_storage_account.example_insecure.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}
