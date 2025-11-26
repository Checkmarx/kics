resource "azurerm_storage_account" "positive1" {
  name                     = "positive1"
  resource_group_name      = azurerm_resource_group.positive1.name
  location                 = azurerm_resource_group.positive1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  # missing "share_properties" (allows all SMB protocols)
}

resource "azurerm_storage_account" "positive2" {
  name                     = "positive2"
  resource_group_name      = azurerm_resource_group.positive2.name
  location                 = azurerm_resource_group.positive2.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  share_properties {
    # missing "smb" (allows all SMB protocols)
  }
}


resource "azurerm_storage_account" "positive3" {
  name                     = "positive3"
  resource_group_name      = azurerm_resource_group.positive3.name
  location                 = azurerm_resource_group.positive3.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  share_properties {
      smb {
        # missing "versions" (allows all SMB protocols)
      }
  }
}

resource "azurerm_storage_account" "positive4" {
  name                     = "positive4"
  resource_group_name      = azurerm_resource_group.positive4.name
  location                 = azurerm_resource_group.positive4.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  share_properties {
      smb {
        versions = []                         # no SMB protocols allowed
      }
  }
}

resource "azurerm_storage_account" "positive5" {
  name                     = "positive5"
  resource_group_name      = azurerm_resource_group.positive5.name
  location                 = azurerm_resource_group.positive5.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  share_properties {
      smb {
        versions = ["SMB2.1", "SMB3.0"]        # missing "SMB3.1.1"
      }
  }
}

resource "azurerm_storage_account" "positive6" {
  name                     = "positive6"
  resource_group_name      = azurerm_resource_group.positive6.name
  location                 = azurerm_resource_group.positive6.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  share_properties {
      smb {
        versions = ["SMB3.1.1", "SMB2.1"]       # allows outdated version
      }
  }
}
