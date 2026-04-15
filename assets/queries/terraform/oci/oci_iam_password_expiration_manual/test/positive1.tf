resource "oci_identity_domains_password_policy" "long_expiration" {
  idcs_endpoint = "https://idcs-..."
  name          = "LongExpirationPolicy"
  # FAIL: > 365
  password_expires_after = 400
  schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:extension:passwordState:User"]
}