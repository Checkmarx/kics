# legacy "log" fields   -  enabled set to "false"
resource "azurerm_kubernetes_cluster" "positive3_1" {
  name                = "myAKSCluster"
  location            = "eastus"
  resource_group_name = "myResourceGroup"
  dns_prefix          = "myakscluster"
}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics_pos3_1" {
  name                       = "myAKSClusterLogs"
  target_resource_id         = azurerm_kubernetes_cluster.positive3_1.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.positive3_1.id

  log {
    category = "kube-audit"
    enabled  = false
  }
}

resource "azurerm_kubernetes_cluster" "positive3_2" {
  name                = "myAKSCluster"
  location            = "eastus"
  resource_group_name = "myResourceGroup"
  dns_prefix          = "myakscluster"
}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics_pos3_2" {
  name                       = "myAKSClusterLogs"
  target_resource_id         = azurerm_kubernetes_cluster.positive3_2.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.positive3_2.id

  log {
    category = "kube-audit"
    enabled  = false
  }

  log {
    category = "kube-audit-admin"
    enabled  = false
  }
}
