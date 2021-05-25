package Cx

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_key_vault[name]

	count({x |
		diagnosticResource := input.document[x].resource.azurerm_monitor_diagnostic_setting[_]
		contains(diagnosticResource.target_resource_id, concat(".", ["azurerm_key_vault", name, "id"]))
	}) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_key_vault[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'azurerm_key_vault' is associated with 'azurerm_monitor_diagnostic_setting'",
		"keyActualValue": "'azurerm_key_vault' is not associated with 'azurerm_monitor_diagnostic_setting'",
	}
}
