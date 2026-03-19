provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "incomplete_gateway_rule" {
  display_name   = "IncompleteGatewayRule"
  compartment_id = "ocid1.tenancy..."
  is_enabled     = true

  # FALLO: Solo tiene Internet Gateway, faltan los otros 12 eventos
  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.virtualnetwork.createinternetgateway",
      "com.oraclecloud.virtualnetwork.updateinternetgateway",
      "com.oraclecloud.virtualnetwork.deleteinternetgateway"
    ]
  })

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic..."
    }
  }
}