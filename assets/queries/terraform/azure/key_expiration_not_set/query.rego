package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.azurerm_key_vault_key[name]

	not resource.expiration_date

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_key_vault_key",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_key_vault_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'expiration_date' should exist",
		"keyActualValue": "'expiration_date' is missing",
	}
}
