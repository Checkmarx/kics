resource "ibm_resource_instance" "cloudant_partial_params" {
  name     = "cloudant-partial"
  service  = "cloudantnosqldb"
  plan     = "standard"
  location = "us-south"

  parameters = {
    "db_type" = "nosql"
  }
}