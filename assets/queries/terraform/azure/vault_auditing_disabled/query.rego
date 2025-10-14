package Cx

import data.generic.terraform as tf_lib

types := {"azurerm_key_vault", "azurerm_databricks_workspace"}

CxPolicy[result] {
	resource := input.document[i].resource[types[t]][name]

	count({x |
		diagnosticResource := input.document[x].resource.azurerm_monitor_diagnostic_setting[_]
		contains(diagnosticResource.target_resource_id, concat(".", [types[t], name, "id"]))
	}) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s]", [types[t], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' should be associated with 'azurerm_monitor_diagnostic_setting'", [types[t]]),
		"keyActualValue": sprintf("'%s' is not associated with 'azurerm_monitor_diagnostic_setting'", [types[t]]),
	}
}
