package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_storage_account[var0]
    object.get(resource, "enable_https_traffic_only", "not found") == "not found"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_storage_account[%s]", [var0]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'azurerm_storage_account.%s.enable_https_traffic_only' equals 'true'", [var0]),
                "keyActualValue": 	sprintf("'azurerm_storage_account.%s.enable_https_traffic_only' does not exist", [var0])
              }
}

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_storage_account[var0]
    resource.enable_https_traffic_only == false

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_storage_account[%s].enable_https_traffic_only", [var0]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_storage_account.%s.enable_https_traffic_only' equals 'true'", [var0]),
                "keyActualValue": 	sprintf("'azurerm_storage_account.%s.enable_https_traffic_only' equals 'false'", [var0])
              }
}
