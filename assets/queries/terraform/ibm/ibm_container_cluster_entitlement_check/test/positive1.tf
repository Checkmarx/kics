provider "ibm" {
  region = "us-south"
}

resource "ibm_container_cluster" "cluster_without_entitlement" {
  name            = "test-cluster"
  datacenter      = "dal10"
  machine_type    = "b3c.4x16"
  hardware        = "shared"
  public_vlan_id  = "123"
  private_vlan_id = "456"
  # FALLO: No se define 'entitlement'
}