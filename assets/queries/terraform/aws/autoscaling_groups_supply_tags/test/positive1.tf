resource "aws_autoscaling_group" "positive1" {
  name                 = "foobar3-terraform-test"
  max_size             = 5
  min_size             = 2
  launch_configuration = aws_launch_configuration.foobar.name
  vpc_zone_identifier  = [aws_subnet.example1.id, aws_subnet.example2.id]
}
