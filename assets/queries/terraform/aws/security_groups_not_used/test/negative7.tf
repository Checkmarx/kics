resource "aws_security_group" "test" {
  name = "test"
  load_balancer_type = "application"
}

module "fake" {
  source = "modules/fake"
  security_group_id = [aws_security_group.test.id]
}
