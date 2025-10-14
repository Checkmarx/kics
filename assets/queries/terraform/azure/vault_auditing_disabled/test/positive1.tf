provider "azurerm" {
  features {
    key_vault {purge_soft_delete_on_destroy = true}
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "example" {
  name     = "resourceGroup1"
  location = "West US"
}

# missing "azurerm_monitor_diagnostic_setting" resource

resource "azurerm_key_vault" "example" {
  name                        = "testvault"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  sku_name = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
}
