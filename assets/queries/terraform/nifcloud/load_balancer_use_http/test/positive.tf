resource "nifcloud_load_balancer" "positive" {
  load_balancer_name = "example"
  instance_port      = 80
  load_balancer_port = 80
}
