package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	response := doc.paths[n][oper].responses[code]
	openapi_lib.content_allowed(oper, code)

	check_status_code(code)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.{{%s}}.responses.{{%s}}", [n, oper, code]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "HTTP responses status codes are in range of [200-599]",
		"keyActualValue": "HTTP responses status codes are not in range of [200-599]",
	}
}

check_status_code(code) {
	s_code := split(code, "")
	n := to_number(s_code[0])
	n < 1
}

check_status_code(code) {
	s_code := split(code, "")
	n := to_number(s_code[0])
	n > 5
}

check_status_code(code) {
	count(code) != 3
}
