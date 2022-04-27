resource "alicloud_ros_stack_instance" "example" {
  stack_group_name          = alicloud_ros_stack_group.example.stack_group_name
  stack_instance_account_id = "example_value"
  stack_instance_region_id  = data.alicloud_ros_regions.example.regions.0.region_id
  operation_preferences     = "{\"FailureToleranceCount\": 1, \"MaxConcurrentCount\": 2}"
  retain_stacks             = false
  parameter_overrides {
    parameter_value = "VpcName"
    parameter_key   = "VpcName"
  }
}
