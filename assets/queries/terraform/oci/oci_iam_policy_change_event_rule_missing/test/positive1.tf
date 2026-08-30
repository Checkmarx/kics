provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_identity_policy" "test_policy" {
  name           = "test-policy"
  description    = "Policy for testing"
  compartment_id = "ocid1.tenancy.oc1.."
  statements     = ["Allow group Administrators to manage all-resources in tenancy"]
}