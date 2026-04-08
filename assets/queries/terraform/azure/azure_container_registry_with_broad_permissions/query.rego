package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_role_assignment[name]

	contains(resource.scope, "azurerm_container_registry.")
	results := get_results(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_role_assignment",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_role_assignment[%s].%s", [name, results.target_resource]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_role_assignment[%s].%s' should be set to '%s'", [name,  results.target_resource, results.expected]),
		"keyActualValue": sprintf("'azurerm_role_assignment[%s].%s' is set to '%s'", [name, results.target_resource, results.actual]),
		"searchLine": results.searchLine
	}
}

get_results(resource, name) = results {
	common_lib.valid_key(resource, "role_definition_name")
	resource.role_definition_name != "AcrPull"
	results := {
		"target_resource" : "role_definition_name",
		"expected" : "AcrPull",
		"actual" : resource.role_definition_name,
		"searchLine": common_lib.build_search_line(["resource", "azurerm_role_assignment", name, "role_definition_name"], [])
	}
} else = results {
	resource.role_definition_id != "7f951dda-4ed3-4680-a7ca-43fe172d538d"
	results := {
		"target_resource" : "role_definition_id",
		"expected" : "7f951dda-4ed3-4680-a7ca-43fe172d538d",
		"actual" : resource.role_definition_id,
		"searchLine": common_lib.build_search_line(["resource", "azurerm_role_assignment", name, "role_definition_id"], [])
	}
}
