resource "aws_launch_configuration" "negative3" {
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "m4.large"
  spot_price    = "0.001"
  user_data_base64 = null
  
  lifecycle {
    create_before_destroy = true
  }
}
