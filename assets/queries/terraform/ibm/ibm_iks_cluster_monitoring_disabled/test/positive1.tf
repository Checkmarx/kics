resource "ibm_container_cluster" "aks_no_monitoring" {
  name            = "blind-cluster"
  datacenter      = "dal10"
  machine_type    = "b3c.4x16"
  hardware        = "shared"
  public_vlan_id  = "vlan1"
  private_vlan_id = "vlan2"
}