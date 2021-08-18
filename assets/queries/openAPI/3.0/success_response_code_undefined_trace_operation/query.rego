package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	response := doc.paths[n].trace.responses

	not common_lib.valid_key(response, "200")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.trace.responses", [n]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Trace should have the '200' successful code set",
		"keyActualValue": "Trace does not have the '200' successful code set",
	}
}
