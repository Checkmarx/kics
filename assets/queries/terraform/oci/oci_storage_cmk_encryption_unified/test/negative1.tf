provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_objectstorage_bucket" "bucket_with_cmk" {
  compartment_id = "ocid1.compartment.oc1..aaaa"
  namespace      = "my-namespace"
  name           = "bucket-secure"
  
  kms_key_id = "ocid1.key.oc1.iad.example"
}