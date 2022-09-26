resource "aws_autoscaling_group" "foo" {
  name_prefix          = "bar-"
  vpc_zone_identifier  = ["subnet-abcd1234", "subnet-1a2b3c4d"]
  launch_configuration = aws_launch_configuration.foobar.name
  target_group_arns    = ["bar", "baz", "qux"]
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}
