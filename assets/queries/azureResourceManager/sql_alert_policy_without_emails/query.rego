package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	types := ["Microsoft.Sql/servers/databases/securityAlertPolicies", "securityAlertPolicies"]

	doc := input.document[i]
	[path, value] := walk(doc)

	value.type == types[_]
	properties := value.properties
	lower(properties.state) == "enabled"

	not commonLib.valid_key(properties, "emailAddresses")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties", [commonLib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "securityAlertPolicies.properties.emailAddresses is defined and contains emails",
		"keyActualValue": "securityAlertPolicies.properties.emailAddresses is not defined",
	}
}

CxPolicy[result] {
	types := ["Microsoft.Sql/servers/databases/securityAlertPolicies", "securityAlertPolicies"]

	doc := input.document[i]
	[path, value] := walk(doc)

	value.type == types[_]
	properties := value.properties
	lower(properties.state) == "enabled"

	check_emails(properties.emailAddresses)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties.emailAddresses", [commonLib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "securityAlertPolicies.properties.emailAddresses is defined and contains emails",
		"keyActualValue": "securityAlertPolicies.properties.emailAddresses doesn't contain emails",
	}
}

check_emails(emailAddresses) {
	count(emailAddresses) == 0
} else {
	count([x |
		email := emailAddresses[_]
		email == ""
		x := email
	]) > 0
}
