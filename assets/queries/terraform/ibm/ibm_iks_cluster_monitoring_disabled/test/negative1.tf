resource "ibm_container_cluster" "aks_with_monitoring" {
  name            = "visible-cluster"
  datacenter      = "dal10"
  machine_type    = "b3c.4x16"
  hardware        = "shared"
}

resource "ibm_ob_monitoring_config" "monitoring_ok" {
  scope    = ibm_container_cluster.aks_with_monitoring.crn
  instance = "crn:v1:bluemix:public:sysdig-monitor:..."
}