resource "ibm_resource_instance" "cloudant_no_params" {
  name     = "cloudant-no-params"
  service  = "cloudantnosqldb"
  plan     = "standard"
  location = "us-south"
}