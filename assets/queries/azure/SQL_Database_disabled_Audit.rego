package Cx

SupportedResources = "$.resource.azurerm_sql_database"

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_sql_database[name]

	not resource.threat_detection_policy

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_sql_database[%s].threat_detection_policy", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "!null",
                "keyActualValue": 	null,
              })
}

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_sql_database[name]

    resource.threat_detection_policy.state == "Disabled"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_sql_database[%s].threat_detection_policy.state", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "Enabled",
                "keyActualValue": 	"Disabled",
              })
}