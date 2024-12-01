package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.azurerm_storage_container[name]

	resource.container_access_type != "private"

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_storage_container",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_storage_container[%s].container_access_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'container_access_type' should equal to 'private'",
		"keyActualValue": "'container_access_type' is not equal to 'private'",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_container", name, "container_access_type"], []),
		"remediation": json.marshal({
			"before": sprintf("%s", [resource.container_access_type]),
			"after": "private",
		}),
		"remediationType": "replacement",
	}
}
