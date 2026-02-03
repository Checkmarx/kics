package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"azurerm_linux_virtual_machine", "azurerm_linux_virtual_machine_scale_set"}

CxPolicy[result] {
	resource := input.document[i].resource[types[t]][name]

	results := get_results(resource, types[t], name)[_]

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s].admin_ssh_key.public_key' should be defined and not null", [types[t], name]),
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

get_results(resource, type, name) = results {
	not common_lib.valid_key(resource, "admin_ssh_key")
	results := [{
		"searchKey": sprintf("%s[%s]", [type, name]),
		"keyActualValue": sprintf("'%s[%s].admin_ssh_key' is undefined or null", [type, name]),
		"searchLine": common_lib.build_search_line(["resource", type, name], [])
	}]
}  else = results {
	is_array(resource.admin_ssh_key)
	results := [x | ssh_key := resource.admin_ssh_key[index]
					not common_lib.valid_key(ssh_key, "public_key")
				x := {"searchKey": sprintf("%s[%s].admin_ssh_key[%d]", [type, name, index]),
				"keyActualValue": sprintf("'%s[%s].admin_ssh_key[%d].public_key' is undefined or null", [type, name, index]),
				"searchLine": common_lib.build_search_line(["resource", type, name, "admin_ssh_key", index], [])
	}]
	results != []
} else = results { # for tfplan support
	is_array(resource.admin_ssh_key)
	resource.admin_ssh_key == []
	results := [{
		"searchKey": sprintf("%s[%s].admin_ssh_key", [type, name]),
		"keyActualValue": sprintf("'%s[%s].admin_ssh_key' is undefined or null", [type, name]),
		"searchLine": common_lib.build_search_line(["resource", type, name, "admin_ssh_key"], [])
	}]
} else = results {
	not is_array(resource.admin_ssh_key)
	not common_lib.valid_key(resource.admin_ssh_key, "public_key")
	results := [{
		"searchKey": sprintf("%s[%s].admin_ssh_key", [type, name]),
		"keyActualValue": sprintf("'%s[%s].admin_ssh_key.public_key' is undefined or null", [type, name]),
		"searchLine": common_lib.build_search_line(["resource", type, name, "admin_ssh_key"], [])
	}]
}
