package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.azurerm_sql_server[name]

	not resource.extended_auditing_policy
    
    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("azurerm_sql_server[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'azurerm_sql_server.%s.extended_auditing_policy' exists",[name]),
                "keyActualValue": 	sprintf("'azurerm_sql_server.%s.extended_auditing_policy' does not exist",[name]),
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
