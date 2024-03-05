resource "nifcloud_load_balancer" "negative" {
  load_balancer_name = "example"
  instance_port      = 443
  load_balancer_port = 443
  ssl_policy_id      = "4"
}
