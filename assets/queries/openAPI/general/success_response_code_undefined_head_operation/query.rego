package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	response := doc.paths[n].head.responses

	not common_lib.valid_key(response, "200")
	not common_lib.valid_key(response, "202")
	not common_lib.valid_key(response, "2XX")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.head.responses", [n]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Head should have at least one successful code (200 or 202)",
		"keyActualValue": "Head does not have any successful code",
		"overrideKey": version,
	}
}
