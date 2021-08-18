package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	not common_lib.valid_key(doc, "security")
	searchKey := {
		"3.0": "openapi",
		"2.0": "swagger",
	}

	result := {
		"documentId": doc.id,
		"searchKey": searchKey[version],
		"issueType": "MissingAttribute",
		"keyExpectedValue": "A default security property should be defined",
		"keyActualValue": "A default security property is not defined",
		"overrideKey": version,
	}
}
