package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib

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
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.disableRBAC", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "disableRBAC should be set to false",
		"keyActualValue": "disableRBAC is set to true",
		"searchLine": common_lib.build_search_line(path, ["spec", "disableRBAC"]),
	}
}
