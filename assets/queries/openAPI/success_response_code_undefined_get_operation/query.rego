package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	response := doc.paths[n].get.responses

	object.get(response, "200", "undefined") == "undefined"
	object.get(response, "202", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.get.responses", [n]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Get should have at least one successful code (200 or 202)",
		"keyActualValue": "Get does not have any successful code",
	}
}
