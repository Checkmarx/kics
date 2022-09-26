resource "aws_autoscaling_group" "my_asg" {
  name_prefix          = format("%s-", var.name)
  vpc_zone_identifier  = var.private_zone_identifiers
  launch_configuration = aws_launch_configuration.config.name
  target_group_arns    = [var.target_group_arns]
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}
