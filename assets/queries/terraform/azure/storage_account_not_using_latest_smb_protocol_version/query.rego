package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[name]

	results := get_results(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": sprintf("'azurerm_storage_account[%s].share_properties.smb.versions' should be defined and exclusively include 'SMB3.1.1'", [name]),
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

get_results(resource, name) = results {
	not common_lib.valid_key(resource, "share_properties")
	results := {
		"searchKey" : sprintf("azurerm_storage_account[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyActualValue" : sprintf("'azurerm_storage_account[%s].share_properties' is undefined or null", [name]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name], [])
	}
} else = results {
	not common_lib.valid_key(resource.share_properties, "smb")
	results := {
		"searchKey" : sprintf("azurerm_storage_account[%s].share_properties", [name]),
		"issueType": "MissingAttribute",
		"keyActualValue" : sprintf("'azurerm_storage_account[%s].share_properties.smb' is undefined or null", [name]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name, "share_properties"], [])
	}
} else = results {
	not common_lib.valid_key(resource.share_properties.smb, "versions")

	results := {
		"searchKey" : sprintf("azurerm_storage_account[%s].share_properties.smb", [name]),
		"issueType": "MissingAttribute",
		"keyActualValue" : sprintf("'azurerm_storage_account[%s].share_properties.smb.versions' is undefined or null", [name]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name, "share_properties", "smb"], [])
	}
} else = results {
	resource.share_properties.smb.versions != ["SMB3.1.1"]

	results := {
		"searchKey" : sprintf("azurerm_storage_account[%s].share_properties.smb.versions", [name]),
		"issueType": "IncorrectValue",
		"keyActualValue" : get_actual_value(resource.share_properties.smb.versions, name),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name, "share_properties", "smb", "versions"], [])
	}
}

get_actual_value(versions, name) = str {
	versions == []
	str := sprintf("'azurerm_storage_account[%s].share_properties.smb.versions' is empty or null", [name])
} else = str {
	not common_lib.inArray(versions, "SMB3.1.1")
	str := sprintf("'azurerm_storage_account[%s].share_properties.smb.versions' does not include 'SMB3.1.1' and instead includes %d outdated version(s)", [name, count(versions)])
} else = str {
	str := sprintf("'azurerm_storage_account[%s].share_properties.smb.versions' includes 'SMB3.1.1' but also includes %d outdated version(s)", [name, count(versions)-1])
}
