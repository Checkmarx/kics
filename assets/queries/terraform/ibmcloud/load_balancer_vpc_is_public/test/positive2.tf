resource "ibm_is_lb" "example" {
  name    = "example-load-balancer"
  subnets = [ibm_is_subnet.example.id]
  profile = "network-private-path"
  # Case: type is not defined, defaults to public 
}