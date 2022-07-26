package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "elbv2.aws.crossplane.io")
	resource.kind == "Listener"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "sslPolicy")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%s.metadata.name={{%s}}.spec.forProvider", [common_lib.concat_path(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "sslPolicy should be defined with a secure protocol or cipher",
		"keyActualValue": "sslPolicy is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "elbv2.aws.crossplane.io")
	resource.kind == "Listener"
	forProvider := resource.spec.forProvider

	policy := forProvider.sslPolicy
	common_lib.weakCipher(policy)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%s.metadata.name={{%s}}.spec.forProvider.sslPolicy", [common_lib.concat_path(path), resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sslPolicy should use a secure protocol or cipher",
		"keyActualValue": "sslPolicy is using a weak cipher",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "sslPolicy"]),
	}
}
