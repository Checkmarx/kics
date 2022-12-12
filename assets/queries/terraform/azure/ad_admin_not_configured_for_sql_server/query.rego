package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	sql_server := input.document[i].resource.azurerm_sql_server[name]
	not adAdminExists(sql_server.name, sql_server.resource_group_name, name)
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_sql_server",
		"resourceName": tf_lib.get_resource_name(sql_server, name),
		"searchKey": sprintf("azurerm_sql_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("A 'azurerm_sql_active_directory_administrator' should be defined for 'azurerm_sql_server[%s]'", [name]),
		"keyActualValue": sprintf("A 'azurerm_sql_active_directory_administrator' is not defined for 'azurerm_sql_server[%s]'", [name]),
	}
}

adAdminExists(server_name, resource_group, n) {
	ad_admin := input.document[i].resource.azurerm_sql_active_directory_administrator[name]
	ad_admin.server_name == server_name
} else {
	ad_admin := input.document[i].resource.azurerm_sql_active_directory_administrator[name]
	ad_admin.server_name == sprintf("${azurerm_sql_server.%s.name}", [n])
} else = false {
	true
}
