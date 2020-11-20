package Cx

CxPolicy [ result ] {
  
  network := input.document[i].resource.azurerm_network_watcher_flow_log[name]
  network.enabled = false
  
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("azurerm_network_watcher_flow_log[%s].enable", [name]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "azurerm_network_watcher_flow_log.enabled is true",
                "keyActualValue":   "azurerm_network_watcher_flow_log.enabled is false"
              }
}


