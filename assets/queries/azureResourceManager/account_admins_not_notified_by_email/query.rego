package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	types := ["Microsoft.Sql/servers/databases/securityAlertPolicies", "securityAlertPolicies"]
	doc := input.document[i]

	[path, value] := walk(doc)
	value.type == types[_]

	properties := value.properties
	
	[state_value, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, properties.state)
	[emailAccountAdmins_value, emailAccountAdmins_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, properties.emailAccountAdmins)

	lower(state_value) == "enabled"
	emailAccountAdmins_value == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.emailAccountAdmins", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("securityAlertPolicies.properties.emailAccountAdmins %s should be set to true", [emailAccountAdmins_type]),
		"keyActualValue": sprintf("securityAlertPolicies.properties.emailAccountAdmins %s is set to false", [emailAccountAdmins_type]),
		"searchLine": common_lib.build_search_line(path, ["properties", "emailAccountAdmins"]),
	}
}

CxPolicy[result] {
	types := ["Microsoft.Sql/servers/databases/securityAlertPolicies", "securityAlertPolicies"]
	doc := input.document[i]

	[path, value] := walk(doc)
	value.type == types[_]

	properties := value.properties

	[state_value, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, properties.state)
	
	lower(state_value) == "enabled"
	not common_lib.valid_key(properties, "emailAccountAdmins")

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "securityAlertPolicies.properties.emailAccountAdmins should be set to true",
		"keyActualValue": "securityAlertPolicies.properties.emailAccountAdmins is missing",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}
