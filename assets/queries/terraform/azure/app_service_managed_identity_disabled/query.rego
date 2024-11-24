package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	function := doc.resource.azurerm_app_service[name]

	not common_lib.valid_key(function, "identity")

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(function, name),
		"searchKey": sprintf("azurerm_app_service[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].identity' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].identity' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name], []),
	}
}
