package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "storage.gcp.crossplane.io")
	resource.kind == "Bucket"
	spec := resource.spec

	not common_lib.valid_key(spec, "logging")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Bucket logging should be defined",
		"keyActualValue": "Bucket logging is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec"]),
	}
}
