resource "oci_core_instance" "positive2" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment..."
  shape               = "VM.Standard2.1"

  shape_config {
    # FALLO: Falta is_secure_boot_enabled (Caso 2)
    ocpus = 1
  }
}