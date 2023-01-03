package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resourceRegistry := input.document[i].resource.azurerm_container_registry[name]
	resourceLock := input.document[i].resource.azurerm_management_lock[k]

	scopeSplitted := split(resourceLock.scope, ".")
	not re_match(scopeSplitted[1], name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_container_registry",
		"resourceName": tf_lib.get_resource_name(resourceRegistry, name),
		"searchKey": sprintf("azurerm_container_registry[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_container_registry[%s] scope' should contain azurerm_management_lock'", [name]),
		"keyActualValue": sprintf("'azurerm_container_registry[%s] scope' does not contain azurerm_management_lock'", [name]),
	}
}
