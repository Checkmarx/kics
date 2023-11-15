resource "databricks_workspace_conf" "positive1" {
  custom_config = {
    "enableIpAccessLists" : true
  }
}

resource "databricks_ip_access_list" "positive1" {
  label     = "allow_in"
  list_type = "ALLOW"
  ip_addresses = [
    "0.0.0.0/0",
    "1.2.5.0/24"
  ]
  depends_on = [databricks_workspace_conf.positive1]
}
