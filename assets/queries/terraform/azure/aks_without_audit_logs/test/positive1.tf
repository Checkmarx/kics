resource "azurerm_kubernetes_cluster" "positive1" {
  name                = "myAKSCluster"
  location            = "eastus"
  resource_group_name = "myResourceGroup"
  dns_prefix          = "myakscluster"
}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics_pos1" {
  name                       = "myAKSClusterLogs"
  target_resource_id         = azurerm_kubernetes_cluster.positive1.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.positive1.id

  enabled_log {
    category = "kube-controller-manager"
  }
}
