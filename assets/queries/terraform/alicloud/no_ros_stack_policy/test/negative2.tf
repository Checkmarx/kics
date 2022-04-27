resource "alicloud_ros_stack" "neg2" {
  stack_name        = "tf-testaccstack"
  template_body     = <<EOF
    {
        "ROSTemplateFormatVersion": "2015-09-01"
    }
    EOF
  stack_policy_url = "oss://ros/stack-policy/demo"

  stack_policy_during_update_body = "oss://ros/stack-policy/demo"
}
