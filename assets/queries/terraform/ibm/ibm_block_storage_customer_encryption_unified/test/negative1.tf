provider "ibm" {
  region = "us-south"
}

resource "ibm_is_volume" "volume_secure" {
  name           = "secure-volume"
  profile        = "general-purpose"
  zone           = "us-south-1"
  
  # CORRECTO: Se define una clave de cifrado
  encryption_key = "crn:v1:bluemix:public:kms:us-south:a/test:test:key:test"
}