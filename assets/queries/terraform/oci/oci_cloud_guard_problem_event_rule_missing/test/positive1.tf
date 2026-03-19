provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_core_instance" "example" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment..."
  shape               = "VM.Standard2.1"
}