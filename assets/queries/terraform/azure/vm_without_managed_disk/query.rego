package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"azurerm_virtual_machine", "azurerm_linux_virtual_machine", "azurerm_windows_virtual_machine", "azurerm_virtual_machine_scale_set"}

CxPolicy[result] {
	resource := input.document[i].resource[types[t]][name]

	results := get_results(resource, name, types[t])

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

get_results(resource, name, type) = results {
	type == "azurerm_virtual_machine"
	not common_lib.valid_key(resource, "storage_os_disk")
	results := {
		"searchKey": sprintf("azurerm_virtual_machine[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_virtual_machine[%s].storage_os_disk' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_virtual_machine[%s].storage_os_disk' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_virtual_machine", name], [])
	}
} else = results {
	type == "azurerm_virtual_machine"
	common_lib.valid_key(resource.storage_os_disk, "vhd_uri")
	results := {
		"searchKey": sprintf("azurerm_virtual_machine[%s].storage_os_disk.vhd_uri", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_virtual_machine[%s].storage_os_disk.vhd_uri' should not be set", [name]),
		"keyActualValue": sprintf("'azurerm_virtual_machine[%s].storage_os_disk.vhd_uri' is set", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_virtual_machine", name, "storage_os_disk", "vhd_uri"], [])
	}
} else = results {
	type == "azurerm_virtual_machine"
	not common_lib.valid_key(resource.storage_os_disk, "managed_disk_id")
	not common_lib.valid_key(resource.storage_os_disk, "managed_disk_type")
	results := {
		"searchKey": sprintf("azurerm_virtual_machine[%s].storage_os_disk", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_virtual_machine[%s].storage_os_disk' should define a 'managed_disk_id' or 'managed_disk_type'", [name]),
		"keyActualValue": sprintf("'azurerm_virtual_machine[%s].storage_os_disk' does not define or sets to null 'managed_disk_id' and 'managed_disk_type'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_virtual_machine", name, "storage_os_disk"], [])
	}
} else = results {
	type == ["azurerm_linux_virtual_machine", "azurerm_windows_virtual_machine"][_]
	not common_lib.valid_key(resource, "os_managed_disk_id")
	results := {
		"searchKey": sprintf("%s[%s]", [type, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s].os_managed_disk_id' should be defined and not null", [type, name]),
		"keyActualValue": sprintf("'%s[%s].os_managed_disk_id' is undefined or null", [type, name]),
		"searchLine": common_lib.build_search_line(["resource", type, name], [])
	}
} else = results {
	type == "azurerm_virtual_machine_scale_set"
	common_lib.valid_key(resource.storage_profile_os_disk, "vhd_containers")
	results := {
		"searchKey": sprintf("%s[%s].storage_profile_os_disk.vhd_containers", [type, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].storage_profile_os_disk.vhd_containers' should not be set", [type, name]),
		"keyActualValue": sprintf("'%s[%s].storage_profile_os_disk.vhd_containers' is set", [type, name]),
		"searchLine": common_lib.build_search_line(["resource", type, name, "storage_profile_os_disk", "vhd_containers"], [])
	}
} else = results {
	type == "azurerm_virtual_machine_scale_set"
	not common_lib.valid_key(resource.storage_profile_os_disk, "managed_disk_type")
	results := {
		"searchKey": sprintf("%s[%s].storage_profile_os_disk", [type, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s].storage_profile_os_disk.managed_disk_type' should be defined and not null", [type, name]),
		"keyActualValue": sprintf("'%s[%s].storage_profile_os_disk.managed_disk_type' is undefined or null", [type, name]),
		"searchLine": common_lib.build_search_line(["resource", type, name, "storage_profile_os_disk"], [])
	}
}
