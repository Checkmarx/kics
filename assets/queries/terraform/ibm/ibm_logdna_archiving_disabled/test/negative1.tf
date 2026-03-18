resource "ibm_logdna_instance" "logs_with_archive" {
  name = "logs-with-archiver"
  plan = "lite"
  target_resource_instance_id = "crn:v1:bluemix:public:logdna:..."
}

resource "ibm_logdna_archive" "archiver_ok" {
  instance_id = ibm_logdna_instance.logs_with_archive.id
  cos {
    api_key      = "secret"
    bucket       = "my-bucket"
    endpoint     = "s3.us-south.cloud-object-storage.appdomain.cloud"
    instance_crn = "crn:v1:bluemix:public:cloud-object-storage:..."
  }
}