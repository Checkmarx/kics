resource "databricks_group" "negative1_group" {
  display_name               = "Some Group"
  allow_cluster_create       = true
  allow_instance_pool_create = true
}

resource "databricks_user" "negative1_user" {
  user_name = "someone@example.com"
}

resource "databricks_group_member" "negative1_member" {
  group_id  = databricks_group.negative1_group.id
  member_id = databricks_user.negative1_user.id
}
