resource "oci_core_instance" "positive3" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment..."
  shape               = "VM.Standard2.1"

  platform_config {
    # FAIL: Set to false (Case 3)
    type                   = "AMD_VM"
    is_secure_boot_enabled = false
  }
}
