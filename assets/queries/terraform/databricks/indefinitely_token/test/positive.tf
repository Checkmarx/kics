resource "databricks_token" "positive" {
  provider = databricks.created_workspace
  comment  = "Terraform Provisioning"
}
