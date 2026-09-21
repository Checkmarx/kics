package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
  # case of no security alert policy (must have a mssql server)
  resources := input.document[i].resource

  not common_lib.valid_key(resources,"azurerm_mssql_server_security_alert_policy")

  common_lib.valid_key(resources,"azurerm_mssql_server")	
  
  mssql_server = resources.azurerm_mssql_server[name]
    
  result := {
    "documentId": input.document[i].id,
    "resourceType": "azurerm_mssql_server",
    "resourceName": mssql_server.name,
	"searchKey": sprintf("azurerm_mssql_server[%s]", [name]),
    "issueType": "MissingAttribute",
    "keyExpectedValue": "Security alert policy should be defined and enabled",
    "keyActualValue": "Security alert policy is undefined",
	"searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server", name], []),
  }
}

CxPolicy[result] {
	# case of security alert policy defined but state is not "Enabled"
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
		"issueType": "IncorrectValue",
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
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mssql_server_security_alert_policy.%s.disabled_alerts' should be empty", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_server_security_alert_policy.%s.disabled_alerts' is not empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server_security_alert_policy", name, "disabled_alerts"], []),
	}
}

any_security_alert_policy(doc, types) {
  [_, value] := walk(doc)
  value.type == types[_]
}
