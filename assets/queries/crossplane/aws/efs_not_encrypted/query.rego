package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib
import future.keywords.in

CxPolicy[result] {
	some docs in input.document
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "efs.aws.crossplane.io")
	resource.kind == "FileSystem"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "encrypted")

	result := {
		"documentId": docs.id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "encrypted should be defined and set to true",
		"keyActualValue": "encrypted is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider"]),
	}
}

CxPolicy[result] {
	some docs in input.document
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "efs.aws.crossplane.io")
	resource.kind == "FileSystem"
	forProvider := resource.spec.forProvider

	forProvider.encrypted == false

	result := {
		"documentId": docs.id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider.encrypted", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "encrypted should be set to true",
		"keyActualValue": "encrypted is set to false",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "encrypted"]),
	}
}
