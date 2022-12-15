package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "microsoft.insights/logprofiles"
	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.retentionPolicy.enabled)
	val == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.properties.retentionPolicy.enabled", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'microsoft.insights/logprofiles' should have 'enabled' %s set to true", [val_type]),
		"keyActualValue": "resource with type 'microsoft.insights/logprofiles' doesn't have 'enabled' set to true",
		"searchLine": common_lib.build_search_line(path, ["properties", "retentionPolicy", "enabled"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "microsoft.insights/logprofiles"

	[days, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.retentionPolicy.days)
	all([days <= 365, days != 0])

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.properties.retentionPolicy.days", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'microsoft.insights/logprofiles' should have 'days' %s set to 0 or higher than 365", [val_type]),
		"keyActualValue": "resource with type 'microsoft.insights/logprofiles' doesn't have 'days' set to 0 or higher than 365",
		"searchLine": common_lib.build_search_line(path, ["properties", "retentionPolicy", "days"]),
	}
}
