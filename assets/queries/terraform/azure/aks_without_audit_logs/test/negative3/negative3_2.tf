resource "azurerm_kubernetes_cluster" "negative3" { # tests project wide referencing
  name                = "myAKSCluster"
  location            = "eastus"
  resource_group_name = "myResourceGroup"
  dns_prefix          = "myakscluster"
}
