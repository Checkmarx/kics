package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

types := ["Microsoft.Sql/servers/databases/auditingSettings", "auditingSettings"]

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == types[_]
	properties := value.properties
	[val, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, properties.state)
	lower(val) == "enabled"
	not common_lib.valid_key(properties, "retentionDays")

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'auditingSettings.properties.retentionDays' should be defined and above 90 days",
		"keyActualValue": "'auditingSettings.properties.retentionDays' is missing",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == types[_]
	properties := value.properties
	[val, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, properties.state)
	lower(val) == "enabled"
	[val_rd, val_rd_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, properties.retentionDays)
	val_rd < 90

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.retentionDays", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'auditingSettings.properties.retentionDays' %s should be defined and above 90 days", [val_rd_type]),
		"keyActualValue": sprintf("'auditingSettings.properties.retentionDays' %s is %d", [val_rd_type, properties.retentionDays]),
		"searchLine": common_lib.build_search_line(path, ["properties", "retentionDays"]),
	}
}
