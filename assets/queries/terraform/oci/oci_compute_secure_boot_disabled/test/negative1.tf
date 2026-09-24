resource "oci_core_instance" "negative1" {
  availability_domain = "AD-1"
  compartment_id      = "ocid1.compartment..."
  shape               = "VM.Standard2.1"

  platform_config {
    # PASS: Secure Boot enabled
    type                   = "AMD_VM"
    is_secure_boot_enabled = true
  }
}
