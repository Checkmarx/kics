provider "ibm" {
  region = "us-south"
}

resource "ibm_database" "db_insecure" {
  name     = "db-standard"
  service  = "databases-for-mongodb"
  plan     = "standard"
  location = "us-south"
  # FALLO: Falta el atributo key_protect_key
}