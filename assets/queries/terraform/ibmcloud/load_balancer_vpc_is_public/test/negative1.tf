# Case: type is defined to private_path
resource "ibm_is_lb" "example" {
  name    = "example-load-balancer"
  subnets = [ibm_is_subnet.example.id]
  profile = "network-private-path"
  type = "private_path"
}