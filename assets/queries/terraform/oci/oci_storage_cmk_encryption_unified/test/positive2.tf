provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_core_volume" "volume_empty_cmk" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment.oc1..aaaa"
  display_name        = "volume-empty"
  
  kms_key_id = ""
}