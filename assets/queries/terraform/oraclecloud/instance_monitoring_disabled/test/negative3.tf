# Case: missing is_monitoring_disabled inside agent_config
resource "oci_core_instance" "fail" {
  availability_domain = var.instance_availability_domain
  compartment_id      = var.compartment_id
  shape               = var.instance_shape
  agent_config {}
}