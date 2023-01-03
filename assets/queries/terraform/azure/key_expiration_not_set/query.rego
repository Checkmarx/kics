package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_key_vault_key[name]

	not resource.expiration_date

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault_key",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_key_vault_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'expiration_date' should exist",
		"keyActualValue": "'expiration_date' is missing",
	}
}
