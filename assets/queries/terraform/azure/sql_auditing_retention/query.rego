package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_sql_database[name]

	var := resource.extended_auditing_policy.retention_in_days
	var <= 90
    
    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_sql_database[%s].extended_auditing_policy.retention_in_days", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'%s.extended_auditing_policy.retention_in_days' is bigger than 90)",[name]),
                "keyActualValue": 	sprintf("'extended_auditing_policy.retention_in_days' is bigger than 90 [%d])",[var]),
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
    resource := input.file[i].resource.azurerm_sql_server[name]

	var := resource.extended_auditing_policy.retention_in_days
	var <= 90
    
    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_sql_server[%s].extended_auditing_policy.retention_in_days", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'%s.extended_auditing_policy.retention_in_days' is bigger than 90)",[name]),
                "keyActualValue": 	sprintf("'extended_auditing_policy.retention_in_days' is bigger than 90 [%d])",[var]),
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
