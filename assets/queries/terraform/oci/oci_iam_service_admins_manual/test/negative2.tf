provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_identity_policy" "project_managers" {
  name           = "ProjectManagersPolicy"
  compartment_id = "ocid1.tenancy..."

  statements = [
    "Allow group ProjectManagers to read instance-family in compartment ProjectA",
    "Allow group KeyManagementUsers to use keys in tenancy" 
  ]
}