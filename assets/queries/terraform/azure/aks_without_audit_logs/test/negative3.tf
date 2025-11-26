resource "azurerm_kubernetes_cluster" "negative2_1" { # identical to negative2 to test project wide referencing
  name                = "myAKSCluster"
  location            = "eastus"
  resource_group_name = "myResourceGroup"
  dns_prefix          = "myakscluster"
}
