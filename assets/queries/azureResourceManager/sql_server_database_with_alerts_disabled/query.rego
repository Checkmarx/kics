package Cx

import data.generic.common as common_lib

CxPolicy[result] {
  # case of no security alert policy 
  types := ["Microsoft.Sql/servers/databases/securityAlertPolicies", "securityAlertPolicies"]
  doc := input.document[i]

  not any_security_alert_policy(doc, types)

  result := {
    "documentId": doc.id,
    "resourceType": "Microsoft.Sql/servers/databases/securityAlertPolicies",
    "resourceName": "n/a",
    "searchKey": "securityAlertPolicies",
    "issueType": "MissingAttribute",
    "keyExpectedValue": "Security alert policy should be defined and enabled",
    "keyActualValue": "No security alert policy found",
    "searchLine": [],
  }
}

any_security_alert_policy(doc, types) {
  [path, value] := walk(doc)
  value.type == types[_]
}

CxPolicy[result] {
	# case of security alert policy defined but not enabled
	types := ["Microsoft.Sql/servers/databases/securityAlertPolicies", "securityAlertPolicies"]
	doc := input.document[i]
	[path, value] := walk(doc)
	value.type == types[x]

	properties := value.properties
	properties != {}
	not lower(properties.state) == "enabled"

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s.name=%s' should be enabled", [common_lib.concat_path(path), value.name]),
		"keyActualValue": sprintf("'%s.name=%s' is not enabled", [common_lib.concat_path(path), value.name]),
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	# case of security alert policy defined and enabled but with disabled alerts
	types := ["Microsoft.Sql/servers/databases/securityAlertPolicies", "securityAlertPolicies"]
	doc := input.document[i]
	[path, value] := walk(doc)
	value.type == types[x]

	properties := value.properties
	properties != {}
	lower(properties.state) == "enabled"
	properties.disabledAlerts[idx] != ""

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.disabledAlerts", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.name=%s.disabledAlerts' should not have values defined", [common_lib.concat_path(path), value.name]),
		"keyActualValue": sprintf("'%s.name=%s.disabledAlerts' has values defined", [common_lib.concat_path(path), value.name]),
		"searchLine": common_lib.build_search_line(path, ["properties", "disabledAlerts", idx]),
	}
}
