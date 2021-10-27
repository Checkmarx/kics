package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "microsoft.insights/logprofiles"
	value.properties.retentionPolicy.enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s.properties.retentionPolicy.enabled", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'microsoft.insights/logprofiles' has 'enabled' property set to true",
		"keyActualValue": "resource with type 'microsoft.insights/logprofiles' doesn't have 'enabled' set to true",
		"searchLine": common_lib.build_search_line(path, ["properties", "retentionPolicy", "enabled"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "microsoft.insights/logprofiles"

	days := value.properties.retentionPolicy.days
	all([days <= 365, days != 0])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s.properties.retentionPolicy.days", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'microsoft.insights/logprofiles' has 'days' property set to 0 or higher than 365",
		"keyActualValue": "resource with type 'microsoft.insights/logprofiles' doesn't have 'days' set to 0 or higher than 365",
		"searchLine": common_lib.build_search_line(path, ["properties", "retentionPolicy", "days"]),
	}
}
