resource "ibm_logdna_instance" "logs_without_archive" {
  name = "logs-only-test"
  plan = "lite"
  target_resource_instance_id = "crn:v1:bluemix:public:logdna:..."
}