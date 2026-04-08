resource "azurerm_managed_disk" "positive1" {
  name                 = "secure-vm-disk"
  location             = azurerm_resource_group.positive1.location
  resource_group_name  = azurerm_resource_group.positive1.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 128

  # missing "secure_vm_disk_encryption_set_id" and "disk_encryption_set_id"
}
