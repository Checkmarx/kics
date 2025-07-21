package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
  # case of no security alert policy 
  resources := input.document[i].resource
	
  not common_lib.valid_key(resources,"azurerm_mssql_server_security_alert_policy")
    
  result := {
    "documentId": input.document[i].id,
    "resourceType": "azurerm_mssql_server_security_alert_policy",
    "resourceName": "n/a",
    "searchKey": "azurerm_mssql_server_security_alert_policy",
    "issueType": "MissingAttribute",
    "keyExpectedValue": "Security alert policy should be defined and enabled",
    "keyActualValue": "Security alert policy in undefined",
    "searchLine": [],
  }
}

any_security_alert_policy(doc, types) {
  [_, value] := walk(doc)
  value.type == types[_]
}

CxPolicy[result] {
	# case of security alert policy defined but not enabled
	resources := input.document[i].resource
	common_lib.valid_key(resources,"azurerm_mssql_server_security_alert_policy")
	resource := resources.azurerm_mssql_server_security_alert_policy[name]

	not common_lib.valid_key(resource, "state")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mssql_server_security_alert_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mssql_server_security_alert_policy[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mssql_server_security_alert_policy.%s.state' should be defined and enabled", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_server_security_alert_policy.%s.state' is not defined and enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server_security_alert_policy", name], []),
	}
}

CxPolicy[result] {
	# case of security alert policy defined but not enabled
	resources := input.document[i].resource
	common_lib.valid_key(resources,"azurerm_mssql_server_security_alert_policy")
	resource := resources.azurerm_mssql_server_security_alert_policy[name]

	common_lib.valid_key(resource, "state")
	not lower(resource.state) == "enabled"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mssql_server_security_alert_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mssql_server_security_alert_policy[%s].state", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mssql_server_security_alert_policy.%s.state' should be enabled", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_server_security_alert_policy.%s.state' is not enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server_security_alert_policy", name, "state"], []),
	}
}

CxPolicy[result] {
	# case of security alert policy defined and enabled but with disabled alerts
    resources := input.document[i].resource
	common_lib.valid_key(resources,"azurerm_mssql_server_security_alert_policy")
	resource := resources.azurerm_mssql_server_security_alert_policy[name]

	lower(resource.state) == "enabled"
    resource.disabled_alerts[idx] != ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mssql_server_security_alert_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mssql_server_security_alert_policy[%s].disabled_alerts", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mssql_server_security_alert_policy.%s.disabled_alerts' should not have values defined ", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_server_security_alert_policy.%s.disabled_alerts' has values defined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server_security_alert_policy", name, "disabled_alerts"], []),
	}
}
