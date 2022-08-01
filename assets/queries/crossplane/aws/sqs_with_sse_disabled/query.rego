package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "sqs.aws.crossplane.io")
	resource.kind == "Queue"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "kmsMasterKeyId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "kmsMasterKeyId should be defined",
		"keyActualValue": "kmsMasterKeyId is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider"]),
	}
}
