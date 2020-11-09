package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_storage_account[var0]
    object.get(resource, "enable_https_traffic_only", "not found") == "not found"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_storage_account[%s]", [var0]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'azurerm_storage_account.%s.enable_https_traffic_only' equals 'true'", [var0]),
                "keyActualValue": 	sprintf("'azurerm_storage_account.%s.enable_https_traffic_only' does not exist", [var0]),
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_storage_account[var0]
    resource.enable_https_traffic_only == false

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_storage_account[%s].enable_https_traffic_only", [var0]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_storage_account.%s.enable_https_traffic_only' equals 'true'", [var0]),
                "keyActualValue": 	sprintf("'azurerm_storage_account.%s.enable_https_traffic_only' equals 'false'", [var0]),
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
