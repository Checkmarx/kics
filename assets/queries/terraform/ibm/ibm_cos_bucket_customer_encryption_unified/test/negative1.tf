provider "ibm" {
  region = "us-south"
}

resource "ibm_cos_bucket" "bucket_secure" {
  bucket_name          = "secure-bucket"
  resource_instance_id = "crn:v1:bluemix:public:cloud-object-storage:..."
  storage_class        = "standard"
  region_location      = "us-south"

  # CORRECTO: Se define la clave de cifrado del cliente
  key_protect          = "crn:v1:bluemix:public:kms:us-south:a/test:test:key:test"
}