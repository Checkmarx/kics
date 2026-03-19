provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_file_storage_file_system" "fs_secure" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment.oc1..aaaa"
  display_name        = "fs-secure"
  
  kms_key_id = "ocid1.key.oc1.iad.example"
}