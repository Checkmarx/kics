resource "oci_core_instance" "negative1" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment..."
  shape               = "VM.Standard2.1"

  agent_config {
    # CORRECTO
    are_legacy_imds_endpoints_disabled = true
  }
}