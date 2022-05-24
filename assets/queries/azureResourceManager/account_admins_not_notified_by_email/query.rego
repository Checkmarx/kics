package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	types := ["Microsoft.Sql/servers/databases/securityAlertPolicies", "securityAlertPolicies"]
	doc := input.document[i]

	[path, value] := walk(doc)
	value.type == types[_]

	properties := value.properties
	lower(properties.state) == "enabled"
	properties.emailAccountAdmins == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.emailAccountAdmins", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "securityAlertPolicies.properties.emailAccountAdmins is set to true",
		"keyActualValue": "securityAlertPolicies.properties.emailAccountAdmins is set to false",
		"searchLine": common_lib.build_search_line(path, ["properties", "emailAccountAdmins"]),
	}
}

CxPolicy[result] {
	types := ["Microsoft.Sql/servers/databases/securityAlertPolicies", "securityAlertPolicies"]
	doc := input.document[i]

	[path, value] := walk(doc)
	value.type == types[_]

	properties := value.properties
	lower(properties.state) == "enabled"
	not common_lib.valid_key(properties, "emailAccountAdmins")

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "securityAlertPolicies.properties.emailAccountAdmins is set to true",
		"keyActualValue": "securityAlertPolicies.properties.emailAccountAdmins is missing",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}
