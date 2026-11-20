package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib

apiVersions = ["ssm.aws.jet.crossplane.io", "ssm.aws.upbound.io"]
CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	count([x | y := startswith(resource.apiVersion,apiVersions[x]); y == true]) > 0

	resource.kind == "Parameter"
	forProvider := resource.spec.forProvider

	forProvider.type == "SecureString"
	not common_lib.valid_key(forProvider, "keyId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider.type", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "keyId should be defined",
		"keyActualValue": "keyId is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "type"]),
	}
}
