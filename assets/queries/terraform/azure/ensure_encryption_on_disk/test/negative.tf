
resource "azurerm_managed_disk" "negative1" {
  name                 = "acctestmd"
  location             = "West US 2"
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
  
  encryption_settings = {
      enabled = true
  }
  tags = {
    environment = "staging"
  }
}