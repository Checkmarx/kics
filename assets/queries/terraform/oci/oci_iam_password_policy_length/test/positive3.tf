resource "oci_identity_authentication_policy" "missing_block" {
  compartment_id = "ocid1.tenancy..."
  # FAIL: No hay bloque password_policy
}