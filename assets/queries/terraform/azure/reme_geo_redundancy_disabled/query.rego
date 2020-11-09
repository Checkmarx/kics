package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_postgresql_server[var0]
	not resource.storage_profile

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_postgresql_server[%s]", [var0]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.resource.storage_profile.geo_redundant_backup' does not exist", [var0]),
                "keyActualValue": 	sprintf("'azurerm_postgresql_server.%s.resource.storage_profile.geo_redundant_backup' exists and equals 'Enabled'", [var0]),
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
    resource := input.file[i].resource.azurerm_postgresql_server[var0]
    resource.storage_profile
	not resource.storage_profile.geo_redundant_backup

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_postgresql_server[%s].resource.storage_profile", [var0]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.resource.storage_profile.geo_redundant_backup' does not exist", [var0]),
                "keyActualValue": 	sprintf("'azurerm_postgresql_server.%s.resource.storage_profile.geo_redundant_backup' exists and equals 'Enabled'", [var0]),
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
    resource := input.file[i].resource.azurerm_postgresql_server[var0]
	resource.storage_profile.geo_redundant_backup != "Enabled"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_postgresql_server[%s].resource.storage_profile.geo_redundant_backup", [var0]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.resource.storage_profile.geo_redundant_backup' is equal 'Disabled'", [var0]),
                "keyActualValue": 	sprintf("'azurerm_postgresql_server.%s.resource.storage_profile.geo_redundant_backup' is equal 'Enabled'", [var0]),
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
