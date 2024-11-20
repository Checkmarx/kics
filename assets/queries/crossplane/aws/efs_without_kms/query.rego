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

	not common_lib.valid_key(forProvider, "kmsKeyID")

	result := {
		"documentId": docs.id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "kmsKeyID should be defined",
		"keyActualValue": "kmsKeyID is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider"]),
	}
}
