package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	response := doc.paths[n].delete.responses

	object.get(response, "200", "undefined") == "undefined"
	object.get(response, "201", "undefined") == "undefined"
	object.get(response, "202", "undefined") == "undefined"
	object.get(response, "204", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.delete.responses", [n]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Delete should have at least one successful code (200, 201, 202 or 204)",
		"keyActualValue": "Delete does not have any successful code",
	}
}
