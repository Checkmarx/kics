package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[name]
	id_reference := sprintf("${azurerm_storage_account.%s.id}", [name])

	not common_lib.valid_key(resource, "customer_managed_key") # assumes valid configuration if cmk is defined

	diagnostic_settings := {x | x := input.document[_].resource.azurerm_monitor_diagnostic_setting[_]} # must be associated with diagnostic_setting
	diagnostic_settings[_].storage_account_id == id_reference

	custom_managed_keys := {x | x := input.document[_].resource.azurerm_storage_account_customer_managed_key[_]}
	not is_associated_with_cmk_resource(custom_managed_keys, id_reference)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey" : sprintf("azurerm_storage_account[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue" : sprintf("'azurerm_storage_account[%s] must be associated with a 'azurerm_storage_account_customer_managed_key' resource and the block 'customer_managed_key' should be set", [name]),
		"keyActualValue" : sprintf("'azurerm_storage_account[%s] is not associated with a 'azurerm_storage_account_customer_managed_key' resource and the 'customer_managed_key' block is undefined or null", [name]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name], [])
	}
}

is_associated_with_cmk_resource(custom_managed_keys, id_reference) {
	custom_managed_keys[_].storage_account_id == id_reference
}
