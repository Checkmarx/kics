package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	sql_server := doc.resource.azurerm_sql_server[name]
	not adAdminExists(sql_server.name, sql_server.resource_group_name, name)

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_sql_server",
		"resourceName": tf_lib.get_resource_name(sql_server, name),
		"searchKey": sprintf("azurerm_sql_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("A 'azurerm_sql_active_directory_administrator' should be defined for 'azurerm_sql_server[%s]'", [name]),
		"keyActualValue": sprintf("A 'azurerm_sql_active_directory_administrator' is not defined for 'azurerm_sql_server[%s]'", [name]),
	}
}

adAdminExists(server_name, resource_group, n) {
	some doc in input.document
	ad_admin := doc.resource.azurerm_sql_active_directory_administrator[name]
	ad_admin.server_name == server_name
} else {
	some doc in input.document
	ad_admin := doc.resource.azurerm_sql_active_directory_administrator[name]
	ad_admin.server_name == sprintf("${azurerm_sql_server.%s.name}", [n])
} else = false
