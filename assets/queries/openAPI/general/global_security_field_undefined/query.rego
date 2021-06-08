package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	object.get(doc, "security", "undefined") == "undefined"
	searchKey := {
		"3.0": "openapi",
		"2.0": "swagger",
	}

	result := {
		"documentId": doc.id,
		"searchKey": searchKey[version],
		"issueType": "MissingAttribute",
		"keyExpectedValue": "A default security scheme should be defined",
		"keyActualValue": "A default security scheme is not defined",
		"overrideKey": version,
	}
}
