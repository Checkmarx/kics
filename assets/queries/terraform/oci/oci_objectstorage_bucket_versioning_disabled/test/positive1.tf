provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_objectstorage_bucket" "bucket_missing_versioning" {
  compartment_id = "ocid1.compartment.oc1..aaaa"
  namespace      = "my-namespace"
  name           = "bucket-no-ver"
  access_type    = "NoPublicAccess"
  # FALLO: Falta el atributo versioning
}