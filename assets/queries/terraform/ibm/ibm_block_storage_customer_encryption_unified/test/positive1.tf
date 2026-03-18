provider "ibm" {
  region = "us-south"
}

resource "ibm_is_volume" "volume_insecure" {
  name    = "insecure-volume"
  profile = "general-purpose"
  zone    = "us-south-1"
  # FALLO: Falta el atributo encryption_key
}