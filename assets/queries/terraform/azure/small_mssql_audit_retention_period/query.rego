package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource_type := ["azurerm_mssql_database", "azurerm_mssql_server"]
	resource := input.document[i].resource[resource_type[t]][name]

	not common_lib.valid_key(resource.extended_auditing_policy,"retention_in_days")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource_type[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].extended_auditing_policy", [resource_type[t], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s.extended_auditing_policy.retention_in_days' should be bigger than 90", [name]),
		"keyActualValue": "'extended_auditing_policy.retention_in_days' is not defined",
		"searchLine": common_lib.build_search_line(["resource",resource_type[t] ,name, "extended_auditing_policy"], []),
		"remediation": "retention_in_days = 200",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource_type := ["azurerm_mssql_database", "azurerm_mssql_server"]
	resource := input.document[i].resource[resource_type[t]][name]

	var := resource.extended_auditing_policy.retention_in_days
	var <= 90

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource_type[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].extended_auditing_policy.retention_in_days", [resource_type[t], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.extended_auditing_policy.retention_in_days' should be bigger than 90", [name]),
		"keyActualValue": sprintf("'extended_auditing_policy.retention_in_days' is %d", [var]),
		"searchLine": common_lib.build_search_line(["resource",resource_type[t] ,name, "extended_auditing_policy", "retention_in_days"], []),
		"remediation": json.marshal({
			"before": sprintf("%d", [var]),
			"after": "200"
		}),
		"remediationType": "replacement",
	}
}
