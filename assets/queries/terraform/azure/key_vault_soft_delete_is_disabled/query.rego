package Cx

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_key_vault[name]
    object.get(resource,"soft_delete_enabled","undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_key_vault[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'azurerm_key_vault.soft_delete_enabled' is set",
		"keyActualValue": "'azurerm_key_vault.soft_delete_enabled' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_key_vault[name]
    object.get(resource,"soft_delete_enabled","undefined") != "undefined"
	not resource.soft_delete_enabled

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_key_vault[%s].soft_delete_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'azurerm_key_vault.soft_delete_enabled' is 'true'",
		"keyActualValue": "'azurerm_key_vault.soft_delete_enabled' is 'false'",
	}
}
