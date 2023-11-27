resource "databricks_obo_token" "negative" {
  depends_on       = [databricks_group_member.this]
  application_id   = databricks_service_principal.this.application_id
  comment          = "PAT on behalf of ${databricks_service_principal.this.display_name}"
  lifetime_seconds = 3600
}
