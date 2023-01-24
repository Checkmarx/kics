resource "databricks_cluster" "positive2" {
  cluster_name            = "Shared Autoscaling"
  spark_version           = data.databricks_spark_version.latest.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 60
  autoscale {
    min_workers = 1
    max_workers = 10
  }
}

resource "databricks_cluster" "positive2_error" {
  cluster_name            = "Shared Autoscaling"
  spark_version           = data.databricks_spark_version.latest.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 60
  autoscale {
    min_workers = 1
    max_workers = 10
  }
}

resource "databricks_permissions" "positive2" {
  cluster_id = databricks_cluster.positive2.id

  access_control {
    group_name       = databricks_group.auto.display_name
    permission_level = "CAN_ATTACH_TO"
  }

  access_control {
    group_name       = databricks_group.eng.display_name
    permission_level = "CAN_RESTART"
  }

  access_control {
    group_name       = databricks_group.ds.display_name
    permission_level = "CAN_MANAGE"
  }
}
