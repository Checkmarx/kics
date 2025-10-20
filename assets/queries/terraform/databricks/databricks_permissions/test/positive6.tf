resource "databricks_job" "positive6" {
  name                = "Featurization"
  max_concurrent_runs = 1

  new_cluster {
    num_workers   = 300
    spark_version = data.databricks_spark_version.latest.id
    node_type_id  = data.databricks_node_type.smallest.id
  }

  notebook_task {
    notebook_path = "/Production/MakeFeatures"
  }
}

resource "databricks_permissions" "positive6" {

  access_control {
    service_principal_name = databricks_service_principal.aws_principal.application_id
    permission_level       = "IS_OWNER"
  }
}
