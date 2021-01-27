package Cx

CxPolicy[result] {
	sql_server := input.document[i].resource.azurerm_sql_server[name]
	not adAdminExists(sql_server.name, sql_server.resource_group_name)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_sql_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("A 'azurerm_sql_active_directory_administrator' is defined for 'azurerm_sql_server[%s]'", [name]),
		"keyActualValue": sprintf("A 'azurerm_sql_active_directory_administrator' is not defined for 'azurerm_sql_server[%s]'", [name]),
	}
}

adAdminExists(server_name, resource_group) = exists {
	ad_admin := input.document[i].resource.azurerm_sql_active_directory_administrator[name]
	ad_admin.resource_group_name == resource_group
	ad_admin.server_name == server_name
	exists = true
} else = false {
	true
}
