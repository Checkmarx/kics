provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_identity_policy" "auditors" {
  name           = "AuditPolicy"
  description    = "Read only access"
  compartment_id = "ocid1.tenancy..."

  statements = [
    "Allow group Auditors to read all-resources in tenancy",
    "Allow group Auditors to inspect users in tenancy"
  ]
}