package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_key_vault[name]

	count({x |
		diagnosticResource := input.document[x].resource.azurerm_monitor_diagnostic_setting[_]
		contains(diagnosticResource.target_resource_id, concat(".", ["azurerm_key_vault", name, "id"]))
	}) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_key_vault[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'azurerm_key_vault' should be associated with 'azurerm_monitor_diagnostic_setting'",
		"keyActualValue": "'azurerm_key_vault' is not associated with 'azurerm_monitor_diagnostic_setting'",
	}
}
