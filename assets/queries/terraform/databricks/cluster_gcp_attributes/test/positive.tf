resource "databricks_cluster" "positive" {
  cluster_name            = "data"
  spark_version           = data.databricks_spark_version.latest.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 50
  }
  gcp_attributes {
    availability           = "PREEMPTIBLE_GCP"
    zone_id                = "AUTO"
  }
}
