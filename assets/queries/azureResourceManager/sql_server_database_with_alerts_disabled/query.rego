package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	types := ["Microsoft.Sql/servers/databases/securityAlertPolicies", "securityAlertPolicies"]
	doc := input.document[i]
	[path, value] := walk(doc)
	value.type == types[x]

	properties := value.properties
	lower(properties.state) == "enabled"
	properties.disabledAlerts[_] != ""

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.name={{%s}}.disabledAlerts", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.name=%s.disabledAlerts' should not have values defined", [common_lib.concat_path(path), value.name]),
		"keyActualValue": sprintf("'%s.name=%s.disabledAlerts' has values defined", [common_lib.concat_path(path), value.name]),
	}
}
