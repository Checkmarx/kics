provider "ibm" {
  region = "us-south"
}

resource "ibm_container_cluster" "secure_cluster" {
  name            = "secure-setup"
  datacenter      = "dal10"
  machine_type    = "b3c.4x16"
  hardware        = "shared"
  public_vlan_id  = "123"
  private_vlan_id = "456"
}

# CORRECTO: Se define la notificación para el VA
resource "ibm_container_va_notification" "alerts" {
  cluster_id = ibm_container_cluster.secure_cluster.id
  email      = "admin@example.com"
}