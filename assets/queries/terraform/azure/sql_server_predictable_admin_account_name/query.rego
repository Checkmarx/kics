package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_sql_server[name]
	count(resource.administrator_login) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_sql_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_sql_server[%s].administrator_login", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_sql_server[%s].administrator_login' should not be empty'", [name]),
		"keyActualValue": sprintf("'azurerm_sql_server[%s].administrator_login' is empty", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_sql_server[name]
	check_predictable(resource.administrator_login)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_sql_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_sql_server[%s].administrator_login", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_sql_server[%s].administrator_login' should not be predictable'", [name]),
		"keyActualValue": sprintf("'azurerm_sql_server[%s].administrator_login' is predictable", [name]),
	}
}

check_predictable(x) {
	predictable_names := {"admin", "administrator", "root", "user", "azure_admin", "azure_administrator", "guest"}
	some i
	lower(x) == predictable_names[i]
}
