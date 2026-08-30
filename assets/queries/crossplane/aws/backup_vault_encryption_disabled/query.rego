package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "backup.aws.jet.crossplane.io")
	resource.kind == "Vault"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "kmsKeyArn")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "kmsKeyArn should be defined",
		"keyActualValue": "kmsKeyArn is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider"]),
	}
}
