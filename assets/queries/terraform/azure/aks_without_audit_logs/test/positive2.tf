# legacy "log" field
resource "azurerm_kubernetes_cluster" "positive2" {
  name                = "myAKSCluster"
  location            = "eastus"
  resource_group_name = "myResourceGroup"
  dns_prefix          = "myakscluster"
}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics_pos2" {
  name                       = "myAKSClusterLogs"
  target_resource_id         = azurerm_kubernetes_cluster.positive2.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.positive2.id

  log {
    category = "kube-controller-manager"
    enabled  = true
  }
}
