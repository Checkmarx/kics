resource "aws_launch_configuration" "negative1" {
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "m4.large"
  spot_price    = "0.001"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "negative2" {
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "m4.large"
  spot_price    = "0.001"
  user_data_base64 = ""

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "negative3" {
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "m4.large"
  spot_price    = "0.001"
  user_data_base64 = "dGVzdA=="
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "negative4" {
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "m4.large"
  spot_price    = "0.001"
  user_data_base64 = null
  
  lifecycle {
    create_before_destroy = true
  }
}