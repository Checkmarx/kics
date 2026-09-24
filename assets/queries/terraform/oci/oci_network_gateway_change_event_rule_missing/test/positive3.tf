provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "disabled_gateway_rule" {
  display_name   = "DisabledGatewayRule"
  compartment_id = "ocid1.tenancy..."
  description    = "Has all events but is disabled"

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.virtualnetwork.createinternetgateway",
      "com.oraclecloud.virtualnetwork.updateinternetgateway",
      "com.oraclecloud.virtualnetwork.deleteinternetgateway",
      "com.oraclecloud.virtualnetwork.createnatgateway",
      "com.oraclecloud.virtualnetwork.updatenatgateway",
      "com.oraclecloud.virtualnetwork.deletenatgateway",
      "com.oraclecloud.virtualnetwork.createservicegateway",
      "com.oraclecloud.virtualnetwork.updateservicegateway",
      "com.oraclecloud.virtualnetwork.deleteservicegateway",
      "com.oraclecloud.virtualnetwork.createdrg",
      "com.oraclecloud.virtualnetwork.updatedrg",
      "com.oraclecloud.virtualnetwork.deletedrg",
      "com.oraclecloud.virtualnetwork.createlocalpeeringgateway",
      "com.oraclecloud.virtualnetwork.updatelocalpeeringgateway",
      "com.oraclecloud.virtualnetwork.deletelocalpeeringgateway"
    ]
  })

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic..."
    }
  }

  is_enabled = false
}