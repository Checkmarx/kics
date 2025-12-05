resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics_neg3" {
  name                       = "myAKSClusterLogs"
  target_resource_id         = azurerm_kubernetes_cluster.negative3.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.negative3.id

  log {
    category = "kube-audit"
    enabled  = true
  }
}
