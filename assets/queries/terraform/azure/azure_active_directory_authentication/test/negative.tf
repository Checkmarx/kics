resource "azurerm_service_fabric_cluster" "negative" {
  name                 = "example-servicefabric"
  resource_group_name  = azurerm_resource_group.example.name
  location             = azurerm_resource_group.example.location
  reliability_level    = "Bronze"
  upgrade_mode         = "Manual"
  cluster_code_version = "7.1.456.959"
  vm_image             = "Windows"
  management_endpoint  = "https://example:80"

  node_type {
    name                 = "first"
    instance_count       = 3
    is_primary           = true
    client_endpoint_port = 2020
    http_endpoint_port   = 80
  }

  azure_active_directory {
    tenant_id = "id"
    cluster_application_id = "id"
    client_application_id = "id"
  }
}
