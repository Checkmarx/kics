provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_core_instance" "instance_explicit_false" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment..."
  shape               = "VM.Standard.E4.Flex"

  launch_options {
    boot_volume_type = "PARAVIRTUALIZED"
    # FALLO: Explícitamente false (sin comentario pegado encima)
    is_pv_encryption_in_transit_enabled = false
  }

  source_details {
    source_id   = "ocid1.image..."
    source_type = "image"
  }
}