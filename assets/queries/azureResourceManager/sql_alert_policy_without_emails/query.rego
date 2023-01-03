package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	types := ["Microsoft.Sql/servers/databases/securityAlertPolicies", "securityAlertPolicies"]

	doc := input.document[i]
	[path, value] := walk(doc)

	value.type == types[_]
	properties := value.properties
	lower(properties.state) == "enabled"

	not common_lib.valid_key(properties, "emailAddresses")

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "securityAlertPolicies.properties.emailAddresses should be defined and contain emails",
		"keyActualValue": "securityAlertPolicies.properties.emailAddresses is not defined",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
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
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.emailAddresses", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "securityAlertPolicies.properties.emailAddresses should be defined and contain emails",
		"keyActualValue": "securityAlertPolicies.properties.emailAddresses doesn't contain emails",
		"searchLine": common_lib.build_search_line(path, ["properties", "emailAddresses"]),
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
