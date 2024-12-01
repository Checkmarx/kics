package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resourceRegistry := document.resource.azurerm_container_registry[name]
	resourceLock := document.resource.azurerm_management_lock[k]

	scopeSplitted := split(resourceLock.scope, ".")
	not re_match(scopeSplitted[1], name)

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_container_registry",
		"resourceName": tf_lib.get_resource_name(resourceRegistry, name),
		"searchKey": sprintf("azurerm_container_registry[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_container_registry[%s] scope' should contain azurerm_management_lock'", [name]),
		"keyActualValue": sprintf("'azurerm_container_registry[%s] scope' does not contain azurerm_management_lock'", [name]),
	}
}
