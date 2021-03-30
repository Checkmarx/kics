resource "aws_launch_configuration" "positive1" {
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "m4.large"
  spot_price    = "0.001"
  user_data_base64 = "IyEvYmluL3NoCmVjaG8gIkhlbGxvIHdvcmxkIg==" # #!/bin/sh echo "Hello world"
  
  lifecycle {
    create_before_destroy = true
  }
}   