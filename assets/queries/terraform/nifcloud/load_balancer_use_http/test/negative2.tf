resource "nifcloud_load_balancer_listener" "negative" {
  load_balancer_name = nifcloud_load_balancer.example.load_balancer_name
  instance_port      = 443
  load_balancer_port = 443
}
