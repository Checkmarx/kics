resource "databricks_cluster" "positive2" {
  cluster_name            = "data"
  spark_version           = data.databricks_spark_version.latest.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 50
  }
  aws_attributes {
    availability           = "SPOT_WITH_FALLBACK"
    zone_id                = "auto"
    first_on_demand        = 0
    spot_bid_price_percent = 100
  }
}
