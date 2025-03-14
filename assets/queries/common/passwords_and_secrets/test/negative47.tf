provider "azurerm" {
  features {}
}

# Example of using an existing Key Vault and secret
data "azurerm_key_vault" "example" {
  name                = "your-key-vault-name"
  resource_group_name = "your-resource-group"
}

data "azurerm_key_vault_secret" "LinuxVmPassword" {
  name          = "your-secret-name"
  key_vault_id  = data.azurerm_key_vault.example.id
}

resource "azurerm_linux_virtual_machine" "example_vm" {
  name                = "example-vm"
  resource_group_name = "your-resource-group"
  location            = "your-location"
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = data.azurerm_key_vault_secret.LinuxVmPassword.value

  network_interface_ids = [
    # Your network interface ID
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

output "vm_password" {
  value     = data.azurerm_key_vault_secret.LinuxVmPassword.value
  sensitive = true
}
