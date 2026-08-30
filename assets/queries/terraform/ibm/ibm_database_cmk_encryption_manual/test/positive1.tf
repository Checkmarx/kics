provider "ibm" {
  region = "us-south"
}

resource "ibm_database" "db_insecure" {
  name     = "db-standard"
  service  = "databases-for-mongodb"
  plan     = "standard"
  location = "us-south"
  # FAIL: Missing The attribute key_protect_key
}