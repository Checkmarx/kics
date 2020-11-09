package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_sql_database[name]

	not resource.threat_detection_policy

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_sql_database[%s].threat_detection_policy", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'threat_detection_policy' exists",
                "keyActualValue": 	"'threat_detection_policy' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
              }
}

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_sql_database[name]

    resource.threat_detection_policy.state == "Disabled"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_sql_database[%s].threat_detection_policy.state", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'threat_detection_policy.state' equal 'Enabled'",
                "keyActualValue": 	"'threat_detection_policy.state' equal 'Disabled'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
              }
}