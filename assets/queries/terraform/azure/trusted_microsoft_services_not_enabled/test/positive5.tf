variable "tags_list" {
  type = list(object({
    environment = string
    team        = string
  }))

  default = [{
    environment = "staging"
    team        = "devops"
  }]
}

resource "azurerm_storage_account" "positive6" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  dynamic "tags" {
    for_each = var.tags_list
    content {
      environment = tags.value.environment
      team        = tags.value.team
    }
  }
}