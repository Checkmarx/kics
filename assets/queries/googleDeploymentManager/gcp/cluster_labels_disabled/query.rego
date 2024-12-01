package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "resourceLabels")

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'resourceLabels' should be defined and not null",
		"keyActualValue": "'resourceLabels' is undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}
