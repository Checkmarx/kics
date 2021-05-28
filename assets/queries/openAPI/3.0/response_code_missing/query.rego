package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	response := doc.paths[n][oper].responses
	oper != "head"

	responses := {"500", "429", "400"}
	object.get(response, responses[x], "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses", [n, oper]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s response is set", [responses[x]]),
		"keyActualValue": sprintf("%s response is undefined", [responses[x]]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	response := doc.paths[n][oper].responses
	operations := {"post", "put", "patch"}
	oper == operations[x]

	object.get(response, "415", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses", [n, oper]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "415 response is set",
		"keyActualValue": "415 response is undefined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	response := doc.paths[n][oper].responses
	operations := {"get", "put", "head", "delete"}
	oper == operations[x]

	object.get(response, "404", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses", [n, oper]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "404 response is set",
		"keyActualValue": "404 response is undefined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	response := doc.paths[n][oper].responses
	oper == "options"

	object.get(response, "200", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses", [n, oper]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "200 response is set",
		"keyActualValue": "200 response is undefined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	response := doc.paths[n][oper].responses
	object.get(doc, "security", "undefined") != "undefined"
	responses := {"401", "403"}

	object.get(response, responses[x], "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses", [n, oper]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s response is set when security field is defined", [responses[x]]),
		"keyActualValue": sprintf("%s response is undefined when security field is defined", [responses[x]]),
	}
}
