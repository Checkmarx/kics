package Cx

import data.generic.common as commonLib

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
		"searchKey": sprintf("%s.name={{%s}}.properties.emailAccountAdmins", [commonLib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "securityAlertPolicies.properties.emailAccountAdmins is set to true",
		"keyActualValue": "securityAlertPolicies.properties.emailAccountAdmins is set to false",
	}
}

CxPolicy[result] {
	types := ["Microsoft.Sql/servers/databases/securityAlertPolicies", "securityAlertPolicies"]
	doc := input.document[i]

	[path, value] := walk(doc)
	value.type == types[_]

	properties := value.properties
	lower(properties.state) == "enabled"
	not commonLib.valid_key(properties, "emailAccountAdmins")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties", [commonLib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "securityAlertPolicies.properties.emailAccountAdmins is set to true",
		"keyActualValue": "securityAlertPolicies.properties.emailAccountAdmins is missing",
	}
}
