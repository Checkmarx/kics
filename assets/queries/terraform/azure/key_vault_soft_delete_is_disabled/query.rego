package Cx

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_key_vault[name]
	not resource.soft_delete_enabled

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_key_vault[%s].soft_delete_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'soft_delete_enabled' is 'true'",
		"keyActualValue": "'soft_delete_enabled' is 'false'",
	}
}
