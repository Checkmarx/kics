package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.azurerm_mssql_server_security_alert_policy[name]

	not common_lib.valid_key(resource, "email_account_admins")

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_mssql_server_security_alert_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mssql_server_security_alert_policy[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mssql_server_security_alert_policy[%s].email_account_admins' should be defined", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_server_security_alert_policy[%s].email_account_admins' is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server_security_alert_policy", name], []),
		"remediation": "email_account_admins = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.azurerm_mssql_server_security_alert_policy[name]

	resource.email_account_admins == false

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_mssql_server_security_alert_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mssql_server_security_alert_policy[%s].email_account_admins", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mssql_server_security_alert_policy[%s].email_account_admins' should be true", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_server_security_alert_policy[%s].email_account_admins' is false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server_security_alert_policy", name, "email_account_admins"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}
