package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "bigquery.v2.dataset"

	resource.properties.access[j].specialGroup == "allAuthenticatedUsers"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.access[%d].specialGroup", [resource.name, j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'access[%d].specialGroup' to be not equal to 'allAuthenticatedUsers'", [j]),
		"keyActualValue": sprintf("'access[%d].specialGroup' is equal to 'allAuthenticatedUsers'", [j]), 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}
