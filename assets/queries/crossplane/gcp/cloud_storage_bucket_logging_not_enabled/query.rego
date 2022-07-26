package Cx

import data.generic.common as common_lib

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
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%smetadata.name={{%s}}.spec", [getPath(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Bucket logging should be defined",
		"keyActualValue": "Bucket logging is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec"]),
	}
}

getPath(path) = result {
	count(path) > 0
	path_string := common_lib.concat_path(path)
	out := array.concat([path_string], ["."])
	result := concat("", out)
} else = result {
	count(path) == 0
	result := ""
}
