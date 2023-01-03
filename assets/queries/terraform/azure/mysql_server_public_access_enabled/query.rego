package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_mysql_server[name]

	not common_lib.valid_key(resource, "public_network_access_enabled")

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_mssql_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mysql_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mysql_server[%s].public_network_access_enabled' should be defined", [name]),
		"keyActualValue": sprintf("'azurerm_mysql_server[%s].public_network_access_enabled' is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_mysql_server" ,name], []),
		"remediation": "public_network_access_enabled = false",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_mysql_server[name]

	resource.public_network_access_enabled == true

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_mssql_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mysql_server[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mysql_server[%s].public_network_access_enabled' should be set to false", [name]),
		"keyActualValue": sprintf("'azurerm_mysql_server[%s].public_network_access_enabled' is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_mysql_server" ,name, "public_network_access_enabled"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}
