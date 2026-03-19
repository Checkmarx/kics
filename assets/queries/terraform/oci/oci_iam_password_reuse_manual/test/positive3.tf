resource "oci_identity_authentication_policy" "legacy_policy" {
  compartment_id = "ocid1.tenancy..."
  
  # FALLO: Recurso Legacy requiere chequeo manual
  password_policy {
    minimum_password_length = 14
  }
}