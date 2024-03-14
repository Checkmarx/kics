package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	response := doc.paths[n].put.responses

	not common_lib.valid_key(response, "200")
	not common_lib.valid_key(response, "201")
	not common_lib.valid_key(response, "202")
	not common_lib.valid_key(response, "204")
	not common_lib.valid_key(response, "2XX")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.put.responses", [n]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Put should have at least one successful code (200, 201, 202 or 204)",
		"keyActualValue": "Put does not have any successful code",
		"overrideKey": version,
	}
}
