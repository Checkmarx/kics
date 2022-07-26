package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "efs.aws.crossplane.io")
	resource.kind == "FileSystem"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "kmsKeyID")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%s.metadata.name={{%s}}.spec.forProvider", [common_lib.concat_path(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "kmsKeyID should be defined",
		"keyActualValue": "kmsKeyID is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider"]),
	}
}
