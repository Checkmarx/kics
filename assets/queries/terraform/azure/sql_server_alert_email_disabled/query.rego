package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_mssql_server_security_alert_policy[name]

	not common_lib.valid_key(resource, "email_account_admins")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("azurerm_mssql_server_security_alert_policy[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mssql_server_security_alert_policy[%s].email_account_admins' is defined", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_server_security_alert_policy[%s].email_account_admins' is undefined", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_mssql_server_security_alert_policy[name]

	resource.email_account_admins == false

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("azurerm_mssql_server_security_alert_policy[%s].email_account_admins", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mssql_server_security_alert_policy[%s].email_account_admins' is true", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_server_security_alert_policy[%s].email_account_admins' is false", [name]),
	}
}
