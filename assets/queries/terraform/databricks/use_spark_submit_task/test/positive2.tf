resource "databricks_job" "positive" {
  name = "Job with multiple tasks"

  job_cluster {
    job_cluster_key = "j"
    new_cluster {
      num_workers   = 2
      spark_version = data.databricks_spark_version.latest.id
      node_type_id  = data.databricks_node_type.smallest.id
    }
  }

  task {
    task_key = "a"

    existing_cluster_id = databricks_cluster.shared.id

    spark_submit_task {
      main_class_name = "com.acme.data.Main"
    }
  }
}
