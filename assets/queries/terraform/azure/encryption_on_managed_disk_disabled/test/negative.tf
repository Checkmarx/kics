
resource "azurerm_managed_disk" "negative1" {
  name                 = "acctestmd"
  location             = "West US 2"
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  encryption_settings {
      enabled = true    # legacy
  }
}

resource "azurerm_managed_disk" "negative2" {
  name                 = "acctestmd"
  location             = "West US 2"
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  encryption_settings {

    disk_encryption_key {
      secret_url = "sample_url"
      source_vault_id = "sample_id"
    }

    key_encryption_key {
      secret_url = "sample_url"
      source_vault_id = "sample_id"
    }

  }
}

resource "azurerm_managed_disk" "negative3" {
  name                 = "acctestmd"
  location             = "West US 2"
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  encryption_settings {
    disk_encryption_key {
      secret_url = "sample_url"
      source_vault_id = "sample_id"
    }
  }
}

resource "azurerm_managed_disk" "negative4" {
  name                 = "acctestmd"
  location             = "West US 2"
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  encryption_settings {
    key_encryption_key {
      secret_url = "sample_url"
      source_vault_id = "sample_id"
    }
  }
}
