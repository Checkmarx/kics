package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib

validValues = [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653]

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "cloudwatchlogs.aws.crossplane.io")
	resource.kind == "LogGroup"
	retention := resource.spec.forProvider.retentionInDays

	not common_lib.inArray(validValues, retention)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider.retentionInDays", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "retentionInDays should be set to a valid value",
		"keyActualValue": "retentionInDays is set to a invalid value",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "retentionInDays"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "cloudwatchlogs.aws.crossplane.io")
	resource.kind == "LogGroup"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "retentionInDays")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "retentionInDays should be set to a valid value",
		"keyActualValue": "retentionInDays is undefined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider"]),
	}
}
