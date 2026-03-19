provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_objectstorage_bucket" "bucket_without_cmk" {
  compartment_id = "ocid1.compartment.oc1..aaaa"
  namespace      = "my-namespace"
  name           = "bucket-insecure"
}