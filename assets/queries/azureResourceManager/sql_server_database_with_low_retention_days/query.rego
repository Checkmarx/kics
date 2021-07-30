package Cx

import data.generic.common as common_lib

types := ["Microsoft.Sql/servers/databases/auditingSettings", "auditingSettings"]

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == types[_]
	properties := value.properties
	lower(properties.state) == "enabled"
	not common_lib.valid_key(properties, "retentionDays")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'auditingSettings.properties.retentionDays' is defined and above 90 days",
		"keyActualValue": "'auditingSettings.properties.retentionDays' is missing",
	}
}

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == types[_]
	properties := value.properties
	lower(properties.state) == "enabled"
	properties.retentionDays < 90

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties.retentionDays", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'auditingSettings.properties.retentionDays' is defined and above 90 days",
		"keyActualValue": sprintf("'auditingSettings.properties.retentionDays' is %d", [properties.retentionDays]),
	}
}
