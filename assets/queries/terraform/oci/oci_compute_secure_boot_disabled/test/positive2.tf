resource "oci_core_instance" "positive2" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment..."
  shape               = "VM.Standard2.1"

  platform_config {
    # FAIL: Missing is_secure_boot_enabled (Case 2)
    type = "AMD_VM"
  }
}
