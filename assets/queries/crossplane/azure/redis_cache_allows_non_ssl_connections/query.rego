package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "cache.azure.crossplane.io")
	resource.kind == "Redis"
	forProvider := resource.spec.forProvider

	forProvider.enableNonSslPort == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider.enableNonSslPort", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "enableNonSslPort should be set to false or undefined",
		"keyActualValue": "enableNonSslPort is set to true",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "enableNonSslPort"]),
	}
}
