provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_identity_user" "test_user" {
  name        = "test-user"
  description = "Test user"
}