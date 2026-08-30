provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "compliant_gateway_rule" {
  display_name   = "CompliantGatewayRule"
  compartment_id = "ocid1.tenancy.oc1..aaaa"
  description    = "Monitors all 15 Network Gateway events"
  is_enabled     = true

  condition = jsonencode({
    "eventType": [
      # Internet Gateway
      "com.oraclecloud.virtualnetwork.createinternetgateway",
      "com.oraclecloud.virtualnetwork.updateinternetgateway",
      "com.oraclecloud.virtualnetwork.deleteinternetgateway",
      # NAT Gateway
      "com.oraclecloud.virtualnetwork.createnatgateway",
      "com.oraclecloud.virtualnetwork.updatenatgateway",
      "com.oraclecloud.virtualnetwork.deletenatgateway",
      # Service Gateway
      "com.oraclecloud.virtualnetwork.createservicegateway",
      "com.oraclecloud.virtualnetwork.updateservicegateway",
      "com.oraclecloud.virtualnetwork.deleteservicegateway",
      # DRG (Dynamic Routing Gateway)
      "com.oraclecloud.virtualnetwork.createdrg",
      "com.oraclecloud.virtualnetwork.updatedrg",
      "com.oraclecloud.virtualnetwork.deletedrg",
      # LPG (Local Peering Gateway)
      "com.oraclecloud.virtualnetwork.createlocalpeeringgateway",
      "com.oraclecloud.virtualnetwork.updatelocalpeeringgateway",
      "com.oraclecloud.virtualnetwork.deletelocalpeeringgateway"
    ]
  })

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic.oc1.iad.aaaa"
      is_enabled  = true
    }
  }
}