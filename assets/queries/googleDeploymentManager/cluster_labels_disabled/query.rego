package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "resourceLabels")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'resourceLabels' to be defined and not null",
		"keyActualValue": "'resourceLabels' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}
