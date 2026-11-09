# Case: missing is_monitoring_disabled property, defaults to false
resource "oci_core_instance" "fail" {
  availability_domain = var.instance_availability_domain
  compartment_id      = var.compartment_id
  shape               = var.instance_shape
}