resource "oci_core_instance" "positive1" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment..."
  shape               = "VM.Standard2.1"
  # FALLO: Falta shape_config (Caso 1)
}