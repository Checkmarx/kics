package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"azurerm_windows_virtual_machine", "azurerm_windows_virtual_machine_scale_set"}

CxPolicy[result] {
	resource := input.document[i].resource[types[t]][name]

	field := automatic_updates_disabled(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s", [types[t], name, field]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].%s' should be set to 'true'", [types[t], name, field]),
		"keyActualValue": sprintf("'%s[%s].%s' is set to '%s'", [types[t], name, field, resource[field]]),
		"searchLine": common_lib.build_search_line(["resource", types[t], name, field], [])
	}
}

automatic_updates_disabled(resource) = "enable_automatic_updates"{
	common_lib.valid_key(resource, "enable_automatic_updates")
	resource.enable_automatic_updates != true
} else = "automatic_updates_enabled" {		# newer field name
	common_lib.valid_key(resource, "automatic_updates_enabled")
	resource.automatic_updates_enabled != true
}
