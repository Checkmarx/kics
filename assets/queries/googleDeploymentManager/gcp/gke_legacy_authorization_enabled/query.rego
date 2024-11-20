package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "container.v1.cluster"

	resource.properties.legacyAbac.enabled == true

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.legacyAbac.enabled", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'legacyAbac.enabled' should be false",
		"keyActualValue": "'legacyAbac.enabled' is true",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "legacyAbac", "enabled"], []),
	}
}
