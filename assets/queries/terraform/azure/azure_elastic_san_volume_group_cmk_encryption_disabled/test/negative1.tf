resource "azurerm_elastic_san_volume_group" "pass" {
  name            = "secure-vg"
  elastic_san_id  = "san-id"
  encryption_type = "EncryptionAtRestWithCustomerManagedKey"

  encryption {
    key_vault_key_id = "https://kv.vault.azure.net/keys/key/v1"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = ["managed_id"]
  }
}