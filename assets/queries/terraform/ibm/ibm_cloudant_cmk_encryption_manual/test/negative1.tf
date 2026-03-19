resource "ibm_resource_instance" "cloudant_secure" {
  name     = "cloudant-secure"
  service  = "cloudantnosqldb"
  plan     = "standard"
  location = "us-south"

  parameters = {
    key_protect_key = "crn:v1:bluemix:public:kms:us-south:a/test:test:key:test"
  }
}