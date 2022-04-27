resource "alicloud_ros_stack" "example" {
  stack_name        = "tf-testaccstack"
  
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
