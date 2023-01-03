package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_app_service[name]

	not common_lib.valid_key(resource, "https_only")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_app_service[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].https_only' should be set", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].https_only' is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_app_service" ,name], []),
		"remediation": "https_only = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_app_service[name]

	resource.https_only != true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_app_service[%s].https_only", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].https_only' should be set to true", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].https_only' is not set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_app_service" ,name, "https_only"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
