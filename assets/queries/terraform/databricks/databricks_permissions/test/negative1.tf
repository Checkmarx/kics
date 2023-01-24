resource "databricks_job" "negative1" {
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

resource "databricks_permissions" "negative1" {
  job_id = databricks_job.negative1.id

  access_control {
    group_name       = "users"
    permission_level = "CAN_VIEW"
  }

  access_control {
    group_name       = databricks_group.auto.display_name
    permission_level = "CAN_MANAGE_RUN"
  }

  access_control {
    group_name       = databricks_group.eng.display_name
    permission_level = "CAN_MANAGE"
  }

  access_control {
    service_principal_name = databricks_service_principal.aws_principal.application_id
    permission_level       = "IS_OWNER"
  }
}
