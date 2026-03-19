provider "ibm" {
  region = "us-south"
}

resource "ibm_database" "db_secure" {
  name              = "db-protected"
  service           = "databases-for-postgresql"
  plan              = "standard"
  location          = "us-south"
  
  # CORRECTO: Se define la clave de cifrado del cliente
  key_protect_key   = "crn:v1:bluemix:public:kms:us-south:a/test:test:key:test"
}