package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	response := doc.paths[n][oper].responses[code]

	not startswith(response["$ref"], "#/components/responses")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.%s.%s.responses.%s.$ref={{%s}}", [n, oper, code, response["$ref"]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "HTTP responses status codes are in range of [200-599]",
		"keyActualValue": "HTTP responses status codes are not in range of [200-599]",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	response := doc.components.responses[name]

	not startswith(response["$ref"], "#/components/responses")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.components.responses.{{%s}}.$ref={{%s}}", [name, response["$ref"]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "HTTP responses status codes are in range of [200-599]",
		"keyActualValue": "HTTP responses status codes are not in range of [200-599]",
	}
}
