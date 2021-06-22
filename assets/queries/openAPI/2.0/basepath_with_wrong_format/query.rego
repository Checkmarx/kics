package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	not regex.match("^/", doc.basePath)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("basePath={{%s}}", [doc.basePath]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'basePath' value matches the pattern '^/'",
		"keyActualValue": "'basePath' value doesn't match the pattern '^/'",
	}
}
