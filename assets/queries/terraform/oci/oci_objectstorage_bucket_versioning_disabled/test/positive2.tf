provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_objectstorage_bucket" "bucket_suspended_versioning" {
  compartment_id = "ocid1.compartment.oc1..aaaa"
  namespace      = "my-namespace"
  name           = "bucket-suspended"
  
  # FALLO: Está suspendido
  versioning = "Suspended"
}