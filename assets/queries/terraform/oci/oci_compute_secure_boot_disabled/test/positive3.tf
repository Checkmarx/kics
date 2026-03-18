resource "oci_core_instance" "positive3" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment..."
  shape               = "VM.Standard2.1"

  shape_config {
    # FALLO: Configurado a false (Caso 3)
    is_secure_boot_enabled = false
  }
}