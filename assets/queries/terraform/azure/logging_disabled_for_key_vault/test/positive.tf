resource "azurerm_key_vault" "example1" {
  name                        = "example1-vault"
  location                    = "West US"
  resource_group_name         = "example-resources"
}
resource "azurerm_key_vault" "example2" {
  name                        = "example2-vault"
  location                    = "West US"
  resource_group_name         = "example-resources"
}

data "azurerm_key_vault" "example2" {
  name                = "example2-vault"
  resource_group_name = "example-resources"
}
resource "azurerm_key_vault" "example3" {
  name                        = "example3-vault"
  location                    = "West US"
  resource_group_name         = "example-resources"
}

data "azurerm_key_vault" "example3" {
  name                = "example3-vault"
  resource_group_name = "example-resources"
}

resource "azurerm_monitor_diagnostic_setting" "example3" {
  name               = "example3"
  target_resource_id = data.azurerm_key_vault.example3.id
  storage_account_id = data.azurerm_storage_account.example.id
}

resource "azurerm_key_vault" "example4" {
  name                        = "example4-vault"
  location                    = "West US"
  resource_group_name         = "example-resources"
}

data "azurerm_key_vault" "example4" {
  name                = "example4-vault"
  resource_group_name = "example-resources"
}

resource "azurerm_monitor_diagnostic_setting" "example4" {
  name               = "example4"
  target_resource_id = data.azurerm_key_vault.example4.id
  storage_account_id = data.azurerm_storage_account.example.id

  log {
    category = "AuditEvent"
    enabled  = false
  }
}
