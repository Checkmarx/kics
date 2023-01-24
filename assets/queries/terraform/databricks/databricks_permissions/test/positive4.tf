resource "databricks_job" "positive4" {
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

resource "databricks_permissions" "positive4" {
  job_id = databricks_job.positive4.id

  access_control {
    group_name       = databricks_group.eng.display_name
    permission_level = "IS_OWNER"
  }
}
