package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_mysql_server[name]
	resource.ssl_enforcement_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mssql_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mysql_server[%s].ssl_enforcement_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mysql_server.%s.ssl_enforcement_enabled' should equal 'true'", [name]),
		"keyActualValue": sprintf("'azurerm_mysql_server.%s.ssl_enforcement_enabled' is equal 'false'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "ssl_enforcement_enabled", name], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
