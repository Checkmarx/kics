# legacy "log" fields
resource "azurerm_kubernetes_cluster" "negative2_1" {
  name                = "myAKSCluster"
  location            = "eastus"
  resource_group_name = "myResourceGroup"
  dns_prefix          = "myakscluster"
}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics_neg2_1" {
  name                       = "myAKSClusterLogs"
  target_resource_id         = azurerm_kubernetes_cluster.negative2_1.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.negative2_1.id

  log {
    category = "kube-audit"
    enabled  = true
  }
}

resource "azurerm_kubernetes_cluster" "negative2_2" {
  name                = "myAKSCluster"
  location            = "eastus"
  resource_group_name = "myResourceGroup"
  dns_prefix          = "myakscluster"
}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics_neg2_2" {
  name                       = "myAKSClusterLogs"
  target_resource_id         = azurerm_kubernetes_cluster.negative2_2.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.negative2_2.id

  log {
    category = "kube-audit-admin"
    enabled  = true
  }
}
