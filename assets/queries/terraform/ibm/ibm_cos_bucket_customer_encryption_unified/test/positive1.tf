provider "ibm" {
  region = "us-south"
}

resource "ibm_cos_bucket" "bucket_insecure" {
  bucket_name          = "insecure-bucket"
  resource_instance_id = "crn:v1:bluemix:public:cloud-object-storage:..."
  storage_class        = "standard"
  region_location      = "us-south"
  # FALLO: Falta el atributo key_protect
}