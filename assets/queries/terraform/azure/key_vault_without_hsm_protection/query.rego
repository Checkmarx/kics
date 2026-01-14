package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_key_vault_key[name]

	not contains(resource.key_type, "HSM")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault_key",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_key_vault_key[%s].key_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_key_vault_key[%s].key_type' should be set to an HSM-backed type ('RSA-HSM' or 'EC-HSM')", [name]),
		"keyActualValue": sprintf("'azurerm_key_vault_key[%s].key_type' is set to '%s'", [name, resource.key_type]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault_key", name, "key_type"], [])
	}
}
