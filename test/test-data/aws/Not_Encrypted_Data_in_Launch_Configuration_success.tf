// some comment
data "aws_launch_configuration" "ubuntu" {
  name = "test-launch-config"

  ephemeral_block_device {
    encrypted = false
  }
}