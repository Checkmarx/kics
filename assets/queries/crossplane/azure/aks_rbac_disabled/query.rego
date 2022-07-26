package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "compute.azure.crossplane.io")
	resource.kind == "AKSCluster"
	spec := resource.spec

	spec.disableRBAC == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%s.metadata.name={{%s}}.spec.disableRBAC", [common_lib.concat_path(path), resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "disableRBAC should be set to false",
		"keyActualValue": "disableRBAC is set to true",
		"searchLine": common_lib.build_search_line(path, ["spec", "disableRBAC"]),
	}
}
