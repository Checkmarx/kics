resource "oci_core_instance" "negative1" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment..."
  shape               = "VM.Standard2.1"

  shape_config {
    # CORRECTO
    is_secure_boot_enabled = true
  }
}