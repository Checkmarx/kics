resource "azurerm_managed_disk" "negative1" {
  name                 = "standard-disk"
  location             = azurerm_resource_group.negative1.location
  resource_group_name  = azurerm_resource_group.negative1.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 128

  disk_encryption_set_id = azurerm_disk_encryption_set.negative1.id
}

resource "azurerm_managed_disk" "negative2" {
  name                 = "secure-vm-disk"
  location             = azurerm_resource_group.negative2.location
  resource_group_name  = azurerm_resource_group.negative2.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 128

  secure_vm_disk_encryption_set_id = azurerm_disk_encryption_set.secure_vm.id
}
