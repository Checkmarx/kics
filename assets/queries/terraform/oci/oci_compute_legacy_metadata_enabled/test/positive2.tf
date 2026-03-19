resource "oci_core_instance" "positive2" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment..."
  shape               = "VM.Standard2.1"

  agent_config {
    # FALLO: Falta atributo (Caso 2)
    is_monitoring_disabled = false
  }
}