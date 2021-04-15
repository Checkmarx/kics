package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.paths[name].parameters[n]
	not startswith(params["$ref"], "#components/parameters/")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.parameters", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object ref points to '#components/parameters'",
		"keyActualValue": "Parameter Object ref doesn't point to '#components/parameters'",
	}
}
