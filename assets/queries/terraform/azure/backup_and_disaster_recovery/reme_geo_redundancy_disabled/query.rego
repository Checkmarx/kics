package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_postgresql_server[var0]
	not resource.storage_profile

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_postgresql_server[%s]", [var0]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.resource.storage_profile.geo_redundant_backup' does not exist", [var0]),
                "keyActualValue": 	sprintf("'azurerm_postgresql_server.%s.resource.storage_profile.geo_redundant_backup' exists and equals 'Enabled'", [var0])
              }
}

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_postgresql_server[var0]
    resource.storage_profile
	not resource.storage_profile.geo_redundant_backup

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_postgresql_server[%s].resource.storage_profile", [var0]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.resource.storage_profile.geo_redundant_backup' does not exist", [var0]),
                "keyActualValue": 	sprintf("'azurerm_postgresql_server.%s.resource.storage_profile.geo_redundant_backup' exists and equals 'Enabled'", [var0])
              }
}

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_postgresql_server[var0]
	resource.storage_profile.geo_redundant_backup != "Enabled"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_postgresql_server[%s].resource.storage_profile.geo_redundant_backup", [var0]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.resource.storage_profile.geo_redundant_backup' is equal 'Disabled'", [var0]),
                "keyActualValue": 	sprintf("'azurerm_postgresql_server.%s.resource.storage_profile.geo_redundant_backup' is equal 'Enabled'", [var0])
              }
}
