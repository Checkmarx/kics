provider "ibm" {
  region = "us-south"
}

resource "ibm_container_cluster" "cluster_with_entitlement" {
  name            = "secure-cluster"
  datacenter      = "dal10"
  machine_type    = "b3c.4x16"
  hardware        = "shared"
  public_vlan_id  = "123"
  private_vlan_id = "456"

  # CORRECTO: Se automatiza el secreto de descarga
  entitlement     = "my-entitlement-key-crn"
}