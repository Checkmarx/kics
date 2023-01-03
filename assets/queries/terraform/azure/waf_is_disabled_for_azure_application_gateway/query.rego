package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	gateway := input.document[i].resource.azurerm_application_gateway[name]
	not common_lib.valid_key(gateway, "waf_configuration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(gateway, name),
		"searchKey": sprintf("azurerm_application_gateway[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_application_gateway[%s]' should be set", [name]),
		"keyActualValue": sprintf("'azurerm_application_gateway[%s]' is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_application_gateway", name], []),
	}
}

CxPolicy[result] {
	gateway := input.document[i].resource.azurerm_application_gateway[name]
	waf := gateway.waf_configuration
	waf.enabled != true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(gateway, name),
		"searchKey": sprintf("azurerm_application_gateway[%s].waf_configuration.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_application_gateway[%s].waf_configuration.enabled' is true", [name]),
		"keyActualValue": sprintf("'azurerm_application_gateway[%s].waf_configuration.enabled' is false", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_application_gateway", name, "waf_configuration", "enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
