resource "alicloud_ros_stack" "example" {
  stack_name        = "tf-testaccstack"
  notification_urls = ["oss://ros/stack-notification/demo"]
  template_body     = <<EOF
    {
        "ROSTemplateFormatVersion": "2015-09-01"
    }
    EOF
  stack_policy_body = <<EOF
    {
        "Statement": [{
            "Action": "Update:Delete",
            "Resource": "*",
            "Effect": "Allow",
            "Principal": "*"
        }]
    }
    EOF
}
