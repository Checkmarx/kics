resource "databricks_workspace_conf" "negative" {
  custom_config = {
    "enableIpAccessLists" : true
  }
}

resource "databricks_ip_access_list" "negative" {
  label     = "allow_in"
  list_type = "ALLOW"
  ip_addresses = [
    "1.2.3.0/24",
    "1.2.5.0/24"
  ]
  depends_on = [databricks_workspace_conf.negative]
}
