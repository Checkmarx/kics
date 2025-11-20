package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_virtual_machine[name]
	resource.os_profile_linux_config.disable_password_authentication == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_virtual_machine",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_virtual_machine[%s].os_profile_linux_config.disable_password_authentication", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_virtual_machine[%s].os_profile_linux_config.disable_password_authentication' should be set to 'true'", [name]),
		"keyActualValue": sprintf("'azurerm_virtual_machine[%s].os_profile_linux_config.disable_password_authentication' is set to 'false'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_virtual_machine", name, "os_profile_linux_config", "disable_password_authentication"], [])
	}
}

CxPolicy[result] {
	types := {"azurerm_linux_virtual_machine_scale_set", "azurerm_linux_virtual_machine"}
	resource := input.document[i].resource[types[t]][name]
	resource.disable_password_authentication == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].disable_password_authentication", [types[t], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].disable_password_authentication' should be set to 'true'", [types[t], name]),
		"keyActualValue": sprintf("'%s[%s].disable_password_authentication' is set to 'false'", [types[t], name]),
		"searchLine": common_lib.build_search_line(["resource", types[t], name, "disable_password_authentication"], [])
	}
}
