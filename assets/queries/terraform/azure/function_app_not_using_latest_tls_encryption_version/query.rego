package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	app := input.document[i].resource.azurerm_function_app[name]

	to_number(app.site_config.min_tls_version) != 1.2

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_function_app",
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": sprintf("azurerm_function_app[%s].site_config.min_tls_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_function_app[%s].site_config.min_tls_version' should be set to '1.2'", [name]),
		"keyActualValue": sprintf("'azurerm_function_app[%s].site_config.min_tls_version' is not set to '1.2'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name, "site_config", "min_tls_version"], []),
		"remediation": json.marshal({
			"before": sprintf("%.1f", [to_number(app.site_config.min_tls_version)]),
			"after": "1.2"
		}),
		"remediationType": "replacement",
	}
}
