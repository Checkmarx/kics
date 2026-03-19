provider "oci" {
  region = "us-ashburn-1"
}

# Caso: OCID hardcoded que contiene 'tenancy'
resource "oci_objectstorage_bucket" "root_bucket" {
  namespace      = "ns"
  name           = "root-bucket"
  compartment_id = "ocid1.tenancy.oc1..aaaa..."
}