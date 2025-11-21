package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

resources := {"azurerm_app_service","azurerm_windows_web_app","azurerm_linux_web_app","azurerm_batch_account","azurerm_eventhub","azurerm_iothub","azurerm_storage_account",
			  "azurerm_logic_app_standard","azurerm_search_service","azurerm_servicebus_namespace","azurerm_stream_analytics_job","azurerm_application_gateway",
			  "azurerm_data_lake_store","azurerm_data_lake_analytics_account"} # legacy

CxPolicy[result] {
	resource := input.document[i].resource[resources[r]][name]

	count({x |
		diagnosticResource := input.document[x].resource.azurerm_monitor_diagnostic_setting[_]
		contains(diagnosticResource.target_resource_id, concat(".", [resources[r], name, "id"]))
	}) == 0

	not storage_account_without_data_lake(resources[r], resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources[r],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s]", [resources[r], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' should be associated with a 'azurerm_monitor_diagnostic_setting' resource", [resources[r]]),
		"keyActualValue": sprintf("'%s' is not associated with a 'azurerm_monitor_diagnostic_setting' resource", [resources[r]]),
		"searchLine": common_lib.build_search_line(["resource", resources[r], name], [])
	}
}

storage_account_without_data_lake("azurerm_storage_account", resource, name) = false {
	storage_data_lake := input.document[_].resource["azurerm_storage_data_lake_gen2_filesystem"][_]
	contains(storage_data_lake.storage_account_id, concat(".", ["azurerm_storage_account", name, "id"]))
} else = true
