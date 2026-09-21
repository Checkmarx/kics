# legacy "log" field
resource "azurerm_kubernetes_cluster" "positive2_1" {
  name                = "myAKSCluster"
  location            = "eastus"
  resource_group_name = "myResourceGroup"
  dns_prefix          = "myakscluster"
}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics_pos2_1" {
  name                       = "myAKSClusterLogs"
  target_resource_id         = azurerm_kubernetes_cluster.positive2_1.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.positive2_1.id

  log {
    category = "kube-controller-manager"
    enabled  = true
  }
}

resource "azurerm_kubernetes_cluster" "positive2_2" {
  name                = "myAKSCluster"
  location            = "eastus"
  resource_group_name = "myResourceGroup"
  dns_prefix          = "myakscluster"
}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics_pos2_2" {
  name                       = "myAKSClusterLogs"
  target_resource_id         = azurerm_kubernetes_cluster.positive2_2.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.positive2_2.id

  log {
    category = "kube-controller-manager"
    enabled  = true
  }

  log {
    category = "kube-apiserver"
    enabled  = true
  }
}