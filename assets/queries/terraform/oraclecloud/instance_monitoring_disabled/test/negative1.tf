# Case: is_monitoring_disabled set to false
resource "oci_core_instance" "fail" {
  availability_domain = var.instance_availability_domain
  compartment_id      = var.compartment_id
  shape               = var.instance_shape
  agent_config {
    is_monitoring_disabled = false
  }
}