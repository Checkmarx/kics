package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_key_vault_secret[name]

	not resource.expiration_date

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault_secret",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_key_vault_secret[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'expiration_date' exists",
		"keyActualValue": "'expiration_date' is missing",
	}
}
