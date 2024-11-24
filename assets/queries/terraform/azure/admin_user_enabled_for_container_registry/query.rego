package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.azurerm_container_registry[name]

	resource.admin_enabled == true

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_container_registry",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_container_registry[%s].admin_enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_container_registry", name, "admin_enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'admin_enabled' equal 'false'",
		"keyActualValue": "'admin_enabled' equal 'true'",
		"remediation": json.marshal({
			"before": "true",
			"after": "false",
		}),
		"remediationType": "replacement",
	}
}
