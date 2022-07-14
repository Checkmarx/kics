package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_sql_active_directory_administrator[name]
	count(resource.login) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_sql_active_directory_administrator",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_sql_active_directory_administrator[%s].login", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_sql_active_directory_administrator[%s].login' should not be empty'", [name]),
		"keyActualValue": sprintf("'azurerm_sql_active_directory_administrator[%s].login' is empty", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_sql_active_directory_administrator[name]
	check_predictable(resource.login)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_sql_active_directory_administrator",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_sql_active_directory_administrator[%s].login", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_sql_active_directory_administrator[%s].login' should not be predictable'", [name]),
		"keyActualValue": sprintf("'azurerm_sql_active_directory_administrator[%s].login' is predictable", [name]),
	}
}

check_predictable(x) {
	predictable_names := {"admin", "administrator", "sqladmin", "root", "user", "azure_admin", "azure_administrator", "guest"}
	some i
	predictable_names[i] == lower(x)
}
