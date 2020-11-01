package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_sql_database[name]

	var := resource.extended_auditing_policy.retention_in_days
	var <= 90
    
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_sql_database[%s].extended_auditing_policy.retention_in_days", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'%s.extended_auditing_policy.retention_in_days' is bigger than 90)",[name]),
                "keyActualValue": 	sprintf("'extended_auditing_policy.retention_in_days' is bigger than 90 [%d])",[var]),
              }
}
