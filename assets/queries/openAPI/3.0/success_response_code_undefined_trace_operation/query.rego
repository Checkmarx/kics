package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	response := doc.paths[n].trace.responses

	object.get(response, "200", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.trace.responses", [n]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Trace should have the '200' successful code set",
		"keyActualValue": "Trace does not have the '200' successful code set",
	}
}
