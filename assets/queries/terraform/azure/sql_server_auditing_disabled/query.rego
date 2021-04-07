package Cx

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_sql_server[name]

	not resource.extended_auditing_policy

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_sql_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_sql_server.%s.extended_auditing_policy' exists", [name]),
		"keyActualValue": sprintf("'azurerm_sql_server.%s.extended_auditing_policy' does not exist", [name]),
	}
}
