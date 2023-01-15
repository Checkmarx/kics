resource "databricks_token" "negative" {
  provider = databricks.created_workspace
  comment  = "Terraform Provisioning"
  // 100 day token
  lifetime_seconds = 8640000
}
