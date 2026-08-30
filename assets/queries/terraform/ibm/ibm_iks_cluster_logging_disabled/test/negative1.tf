resource "ibm_container_cluster" "secure_cluster" {
  name            = "compliant-cluster"
  datacenter      = "dal10"
  machine_type    = "b3c.4x16"
  hardware        = "shared"
  public_vlan_id  = "123"
  private_vlan_id = "456"
}

resource "ibm_ob_logging_config" "logging_ok" {
  scope    = ibm_container_cluster.secure_cluster.crn
  instance = "crn:v1:bluemix:public:logdna:..."
}