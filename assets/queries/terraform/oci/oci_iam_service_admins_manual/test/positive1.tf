provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_identity_policy" "network_admins" {
  name           = "NetworkAdmins"
  description    = "Admins for VCN"
  compartment_id = "ocid1.tenancy..."
  
  statements = [
    "Allow group NetworkAdmins to manage virtual-network-family in tenancy"
  ]
}

resource "oci_identity_policy" "super_admin" {
  name           = "SuperAdmins"
  description    = "God mode"
  compartment_id = "ocid1.tenancy..."

  statements = [
    "Allow group SuperUsers to MANAGE all-resources in tenancy"
  ]
}