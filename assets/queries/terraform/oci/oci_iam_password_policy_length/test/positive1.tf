resource "oci_identity_authentication_policy" "weak_policy" {
  compartment_id = "ocid1.tenancy..."
  
  password_policy {
    # FALLO: 8 es menor que 14
    minimum_password_length = 8
    is_lowercase_characters_required = true
  }
}