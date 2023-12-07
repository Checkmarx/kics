data "databricks_node_type" "positive3_with_gpu" {
  local_disk  = true
  min_cores   = 16
  gb_per_core = 1
  min_gpus    = 1
}

resource "databricks_cluster" "positive3_research" {
  cluster_name            = "Research Cluster"
  spark_version           = "3.3.1"
  node_type_id            = data.databricks_node_type.positive2_with_gpu.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 50
  }
}
