resource "oci_core_instance" "positive3" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment..."
  shape               = "VM.Standard2.1"

  agent_config {
    # FALLO: Valor incorrecto (Caso 3)
    are_legacy_imds_endpoints_disabled = false
  }
}