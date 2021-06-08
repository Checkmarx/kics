package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	url := doc.paths[path][operation].externalDocs.url
	not openapi_lib.is_valid_url(url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.externalDocs.url", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.externalDocs.url has a valid URL", [path, operation]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.externalDocs.url has a invalid URL", [path, operation]),
		"overrideKey": version,
	}
}
