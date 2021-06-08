package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	url := doc.tags[x].externalDocs.url
	name := doc.tags[x].name
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("tags.name=%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tags[%d].externalDocs.url has a valid URL", [x]),
		"keyActualValue": sprintf("tags[%d].externalDocs.url has an invalid URL", [x]),
		"overrideKey": version,
	}
}
