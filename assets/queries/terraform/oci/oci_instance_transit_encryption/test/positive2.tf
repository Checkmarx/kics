provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_core_instance" "instance_missing_attribute" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment..."
  shape               = "VM.Standard.E4.Flex"

  # The block Exists, but Missing The attribute de encriptación
  launch_options {
    boot_volume_type = "PARAVIRTUALIZED"
    network_type     = "PARAVIRTUALIZED"
  }
}