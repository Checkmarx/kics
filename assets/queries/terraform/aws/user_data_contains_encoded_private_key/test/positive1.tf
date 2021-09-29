resource "aws_launch_configuration" "positive1" {
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "m4.large"
  spot_price    = "0.001"
  user_data_base64 = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpzb21lS2V5" # someKey

  lifecycle {
    create_before_destroy = true
  }
}
