package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

target_resources := {"azurerm_key_vault", "azurerm_application_gateway", "azurerm_firewall", "azurerm_lb", "azurerm_public_ip",
					"azurerm_frontdoor", "azurerm_cdn_frontdoor_profile", "azurerm_cdn_frontdoor_endpoint", "azurerm_cdn_profile",
					"azurerm_cdn_endpoint", "azurerm_storage_account", "azurerm_mssql_server", "azurerm_mssql_managed_instance",
					"azurerm_mssql_database", "azurerm_cosmosdb_account", "azurerm_linux_web_app", "azurerm_windows_web_app",
					"azurerm_linux_function_app", "azurerm_windows_function_app", "azurerm_kubernetes_cluster", "azurerm_eventhub_namespace",
					"azurerm_servicebus_namespace", "azurerm_container_registry", "azurerm_api_management"}

CxPolicy[result] {
	resource := input.document[i].data.azurerm_subscription[name]			# subscription (data)

	not diagnostic_setting_associated_with_subscription(input.document[i], name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_subscription",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_subscription[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_subscription[%s]' should be associated with a 'azurerm_monitor_diagnostic_setting' resource", [name]),
		"keyActualValue": sprintf("'azurerm_subscription[%s]' is not associated with a 'azurerm_monitor_diagnostic_setting' resource", [name]),
		"searchLine": common_lib.build_search_line(["data", "azurerm_subscription", name], [])
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[target_resources[t]][name]			# individual resources

	not diagnostic_setting_associated_with_target_resource(input.document[i], target_resources[t], name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": target_resources[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s]", [target_resources[t], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s]' should be associated with a 'azurerm_monitor_diagnostic_setting' resource", [target_resources[t], name]),
		"keyActualValue": sprintf("'%s[%s]' is not associated with a 'azurerm_monitor_diagnostic_setting' resource", [target_resources[t], name]),
		"searchLine": common_lib.build_search_line(["resource", target_resources[t], name], [])
	}
}

diagnostic_setting_associated_with_subscription(doc, sub_name) {
	doc.resource.azurerm_monitor_diagnostic_setting[_].target_resource_id == sprintf("${data.azurerm_subscription.%s.id}", [sub_name])
}

diagnostic_setting_associated_with_target_resource(doc, target_type, target_name) {
	doc.resource.azurerm_monitor_diagnostic_setting[_].target_resource_id == sprintf("${%s.%s.id}", [target_type, target_name])
}
