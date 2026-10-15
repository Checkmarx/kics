resource "azurerm_managed_lustre_file_system" "pass" {
  name                   = "pass-lustre"
  resource_group_name    = "rg"
  location               = "West Europe"
  sku_name               = "AMLFS-Durable-Premium-250"
  subnet_id              = "subnet-id"
  storage_capacity_in_tb = 48

  encryption_key {
    key_url         = "https://kv.vault.azure.net/keys/key/v1"
    source_vault_id = "/subscriptions/000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv"
  }
}