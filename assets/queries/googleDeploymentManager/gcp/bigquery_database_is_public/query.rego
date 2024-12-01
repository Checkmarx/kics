package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "bigquery.v2.dataset"

	resource.properties.access[j].specialGroup == "allAuthenticatedUsers"

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.access[%d].specialGroup", [resource.name, j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'access[%d].specialGroup' should not equal to 'allAuthenticatedUsers'", [j]),
		"keyActualValue": sprintf("'access[%d].specialGroup' is equal to 'allAuthenticatedUsers'", [j]),
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "access", j, "specialGroup"], []),
	}
}
