package Cx

import data.generic.common as common_lib


types := ["Microsoft.Sql/servers/databases/securityAlertPolicies", "securityAlertPolicies"]

CxPolicy[result] {
  # case of no security alert policy
  dbTypes := {"Microsoft.Sql/servers/databases", "databases", "Microsoft.Sql/servers"}
  doc := input.document[i]

  not any_security_alert_policy(doc, types)

  [path, value] := walk(doc)
  value.type == dbTypes[x]

  result := {
    "documentId": doc.id,
    "resourceType": value.type,
    "resourceName": value.name,
	"searchKey": sprintf("%s.name={{%s}}", [common_lib.concat_path(path), value.name]),
    "issueType": "MissingAttribute",
    "keyExpectedValue": "Security alert policy should be defined and enabled",
    "keyActualValue": "Security alert policy is undefined",
	"searchLine": common_lib.build_search_line(path, []),
  }
}

CxPolicy[result] {
	# case of security alert policy defined but state is not "Enabled"
	doc := input.document[i]
	[path, value] := walk(doc)
	value.type == types[x]

	properties := value.properties
	not lower(properties.state) == "enabled"

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.name=%s.state' should be enabled", [common_lib.concat_path(path), value.name]),
		"keyActualValue": sprintf("'%s.name=%s.state' is not enabled", [common_lib.concat_path(path), value.name]),
		"searchLine": common_lib.build_search_line(path, ["properties", "state"]),
	}
}

CxPolicy[result] {
	# case of security alert policy defined and enabled but with disabled alerts
	doc := input.document[i]
	[path, value] := walk(doc)
	value.type == types[x]

	properties := value.properties
	lower(properties.state) == "enabled"
	properties.disabledAlerts[idx] != ""

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.disabledAlerts", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.name=%s.disabledAlerts' should be empty", [common_lib.concat_path(path), value.name]),
		"keyActualValue": sprintf("'%s.name=%s.disabledAlerts' is not empty", [common_lib.concat_path(path), value.name]),
		"searchLine": common_lib.build_search_line(path, ["properties", "disabledAlerts", idx]),
	}
}


any_security_alert_policy(doc, types)  {
  [_, value] := walk(doc)
  value.type == types[_]
} 