provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_core_instance" "instance_missing_block" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment..."
  shape               = "VM.Standard.E4.Flex"

  # Does not exist The block launch_options
  source_details {
    source_id   = "ocid1.image..."
    source_type = "image"
  }
}