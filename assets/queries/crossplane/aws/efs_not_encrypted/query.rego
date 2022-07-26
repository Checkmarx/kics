package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "efs.aws.crossplane.io")
	resource.kind == "FileSystem"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "encrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%s.metadata.name={{%s}}.spec.forProvider", [common_lib.concat_path(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "encrypted should be defined and set to true",
		"keyActualValue": "encrypted is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "efs.aws.crossplane.io")
	resource.kind == "FileSystem"
	forProvider := resource.spec.forProvider

	forProvider.encrypted == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%s.metadata.name={{%s}}.spec.forProvider.encrypted", [common_lib.concat_path(path), resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "encrypted should be set to true",
		"keyActualValue": "encrypted is set to false",
		"searchLine": common_lib.build_search_line(path ,["spec", "forProvider","encrypted"]),
	}
}
