package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_postgresql_server[var0]
	not resource.ssl_enforcement_enabled

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_postgresql_server[%s].ssl_enforcement_enabled", [var0]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.ssl_enforcement_enabled' is equal 'true'", [var0]),
                "keyActualValue": 	sprintf("'azurerm_postgresql_server.%s.ssl_enforcement_enabled' is equal 'false'", [var0]),
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}