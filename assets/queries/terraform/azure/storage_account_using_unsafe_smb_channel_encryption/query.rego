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
		"keyExpectedValue": sprintf("'azurerm_storage_account[%s].share_properties.smb.channel_encryption_type' should be defined and exclusively include 'AES-256-GCM'", [name]),
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
	not common_lib.valid_key(resource.share_properties.smb, "channel_encryption_type")

	results := {
		"searchKey" : sprintf("azurerm_storage_account[%s].share_properties.smb", [name]),
		"issueType": "MissingAttribute",
		"keyActualValue" : sprintf("'azurerm_storage_account[%s].share_properties.smb.channel_encryption_type' is undefined or null", [name]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name, "share_properties", "smb"], [])
	}
} else = results {
	resource.share_properties.smb.channel_encryption_type != ["AES-256-GCM"]

	results := {
		"searchKey" : sprintf("azurerm_storage_account[%s].share_properties.smb.channel_encryption_type", [name]),
		"issueType": "IncorrectValue",
		"keyActualValue" : get_actual_value(resource.share_properties.smb.channel_encryption_type, name),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name, "share_properties", "smb", "channel_encryption_type"], [])
	}
}

get_actual_value(channel_encryption_types, name) = str {
	channel_encryption_types == []
	str := sprintf("'azurerm_storage_account[%s].share_properties.smb.channel_encryption_type' is empty or null", [name])
} else = str {
	not common_lib.inArray(channel_encryption_types, "AES-256-GCM")
	str := sprintf("'azurerm_storage_account[%s].share_properties.smb.channel_encryption_type' does not include 'AES-256-GCM' and instead includes %d weaker encryption standard(s)", [name, count(channel_encryption_types)])
} else = str {
	str := sprintf("'azurerm_storage_account[%s].share_properties.smb.channel_encryption_type' includes 'AES-256-GCM' but also includes %d weaker encryption standard(s)", [name, count(channel_encryption_types)-1])
}
