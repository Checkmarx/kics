package Cx

import data.generic.terraform as tf_lib
import future.keywords.if
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	vm := document.resource.azurerm_virtual_machine[name]
	object.get(vm, "os_profile_linux_config", false)
	vm.os_profile_linux_config.disable_password_authentication == false
	resource_type := "azurerm_virtual_machine"
	result := {
		"documentId": document.id,
		"resourceType": resource_type,
		"resourceName": tf_lib.get_resource_name(vm, name),
		"searchKey": sprintf("%s[%s].admin_ssh_key", [resource_type, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s]' should be using SSH keys for authentication", [resource_type, name]),
		"keyActualValue": sprintf("'%s[%s]' is using username and password for authentication", [resource_type, name]),
	}
}

CxPolicy[result] {
	some document in input.document
	vm := document.resource.azurerm_linux_virtual_machine[name]
	vm.disable_password_authentication == false
	resource_type := "azurerm_linux_virtual_machine"
	result := {
		"documentId": document.id,
		"resourceType": resource_type,
		"resourceName": tf_lib.get_resource_name(vm, name),
		"searchKey": sprintf("%s[%s].admin_ssh_key", [resource_type, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s]' should be using SSH keys for authentication", [resource_type, name]),
		"keyActualValue": sprintf("'%s[%s]' is using username and password for authentication", [resource_type, name]),
	}
}
