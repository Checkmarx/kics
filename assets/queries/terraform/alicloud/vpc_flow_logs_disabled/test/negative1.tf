resource "alicloud_vpc" "main" {
  cidr_block = "192.168.0.0/24"
  name       = var.name
}

resource "alicloud_vpc_flow_log" "default" {
  depends_on     = ["alicloud_vpc.main"]
  resource_id    = alicloud_vpc.main.id
  resource_type  = "VPC"
  traffic_type   = "All"
  log_store_name = var.log_store_name
  project_name   = var.project_name
  flow_log_name  = var.name
  status         = "Active"
}
