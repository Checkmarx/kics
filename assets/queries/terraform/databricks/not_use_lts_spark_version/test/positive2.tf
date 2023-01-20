data "databricks_node_type" "positive2_with_gpu" {
  local_disk  = true
  min_cores   = 16
  gb_per_core = 1
  min_gpus    = 1
}

data "databricks_spark_version" "positive2_gpu_ml" {
  gpu = true
  ml  = true
  long_term_support = false
}

resource "databricks_cluster" "positive2_research" {
  cluster_name            = "Research Cluster"
  spark_version           = data.databricks_spark_version.positive2_gpu_ml.id
  node_type_id            = data.databricks_node_type.positive2_with_gpu.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 50
  }
}
