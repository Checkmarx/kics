resource "nifcloud_load_balancer_listener" "positive" {
  load_balancer_name = nifcloud_load_balancer.example.load_balancer_name
  instance_port      = 80
  load_balancer_port = 80
}
