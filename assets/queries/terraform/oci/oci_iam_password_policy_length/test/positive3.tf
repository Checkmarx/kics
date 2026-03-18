resource "oci_identity_authentication_policy" "missing_block" {
  compartment_id = "ocid1.tenancy..."
  # FALLO: No hay bloque password_policy
}