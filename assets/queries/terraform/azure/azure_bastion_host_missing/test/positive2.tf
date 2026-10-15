resource "azurerm_bastion_host" "fail_no_ip_config" {
  name                = "bastion-incomplete"
  location            = "West Europe"
  resource_group_name = "rg-test"
  # FAIL: Missing required ip_configuration block
}
