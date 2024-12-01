package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	vm := document.resource.azurerm_virtual_machine[name]

	count(vm.network_interface_ids) == 0

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_virtual_machine",
		"resourceName": tf_lib.get_resource_name(vm, name),
		"searchKey": sprintf("azurerm_virtual_machine[%s].network_interface_ids", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_virtual_machine[%s].network_interface_ids' list should not be empty", [name]),
		"keyActualValue": sprintf("'azurerm_virtual_machine[%s].network_interface_ids' list is empty", [name]),
	}
}
