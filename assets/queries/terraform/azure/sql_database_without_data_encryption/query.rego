package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_mssql_database[name]

	resource.transparent_data_encryption_enabled != true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mssql_database",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mssql_database[%s].transparent_data_encryption_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mssql_database[%s].transparent_data_encryption_enabled' should be set to 'true'", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_database[%s].transparent_data_encryption_enabled' is set to '%s'", [name, resource.transparent_data_encryption_enabled]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_database", name, "transparent_data_encryption_enabled"], [])
	}
}
