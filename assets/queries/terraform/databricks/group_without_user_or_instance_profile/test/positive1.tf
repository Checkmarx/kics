resource "databricks_group" "positive_group" {
  display_name               = "Some Group"
  allow_cluster_create       = true
  allow_instance_pool_create = true
}

resource "databricks_user" "positive_user" {
  user_name = "someone@example.com"
}

resource "databricks_group_member" "positive_member" {
  group_id  = databricks_group.positive_group.id
  member_id = databricks_user.positive_user.id
}

resource "databricks_group" "positive_group_2" {
  display_name               = "Some Group"
  allow_cluster_create       = true
  allow_instance_pool_create = true
}
