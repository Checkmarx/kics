resource "azurerm_key_vault" "fail_kv" {
  name                = "kvfail"
  location            = "West Europe"
  resource_group_name = "rg"
  tenant_id           = "00000000-0000-0000-0000-000000000000"
  sku_name            = "standard"
}