resource "azurerm_kubernetes_cluster" "positive1_1" {
  name                = "myAKSCluster"
  location            = "eastus"
  resource_group_name = "myResourceGroup"
  dns_prefix          = "myakscluster"
}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics_pos1_1" {
  name                       = "myAKSClusterLogs"
  target_resource_id         = azurerm_kubernetes_cluster.positive1_1.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.positive1_1.id

  enabled_log {
    category = "kube-controller-manager"
  }
}

resource "azurerm_kubernetes_cluster" "positive1_2" {
  name                = "myAKSCluster"
  location            = "eastus"
  resource_group_name = "myResourceGroup"
  dns_prefix          = "myakscluster"
}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics_pos1_2" {
  name                       = "myAKSClusterLogs"
  target_resource_id         = azurerm_kubernetes_cluster.positive1_2.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.positive1_2.id

  enabled_log {
    category = "kube-controller-manager"
  }

  enabled_log {
    category = "kube-apiserver"
  }
}
