package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	response := doc.paths[n][oper].responses
	oper != "head"

	responses := {"500", "429", "400"}
	wantedResponses := responses[_]
	not common_lib.valid_key(response, wantedResponses)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses", [n, oper]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s response should be set", [wantedResponses]),
		"keyActualValue": sprintf("%s response is undefined", [wantedResponses]),
		"searchValue": sprintf("%s", [wantedResponses]),
		"overrideKey": version,
		"searchValue": sprintf("%s response", [wantedResponses]),
		"searchLine": common_lib.build_search_line(["paths", n, oper, "responses"],[]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	response := doc.paths[n][oper].responses
	operations := {"post", "put", "patch"}
	oper == operations[x]

	not common_lib.valid_key(response, "415")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses", [n, oper]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "415 response should be set",
		"keyActualValue": "415 response is undefined",
		"overrideKey": version,
		"searchValue": "415 response",
		"searchLine": common_lib.build_search_line(["paths", n, oper, "responses"],[]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	response := doc.paths[n][oper].responses
	operations := {"get", "put", "head", "delete"}
	oper == operations[x]

	not common_lib.valid_key(response, "404")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses", [n, oper]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "404 response should be set",
		"keyActualValue": "404 response is undefined",
		"overrideKey": version,
		"searchValue": "404 response",
		"searchLine": common_lib.build_search_line(["paths", n, oper, "responses"],[]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	response := doc.paths[n][oper].responses
	oper == "options"

	not common_lib.valid_key(response, "200")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses", [n, oper]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "200 response should be set",
		"keyActualValue": "200 response is undefined",
		"overrideKey": version,
		"searchValue": "200 response",
		"searchLine": common_lib.build_search_line(["paths", n, oper, "responses"],[]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	response := doc.paths[n][oper].responses
	common_lib.valid_key(doc, "security")
	responses := {"401", "403"}
	wantedResponses := responses[_]

	not common_lib.valid_key(response, wantedResponses)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses", [n, oper]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s response should be set when security field is defined", [wantedResponses]),
		"keyActualValue": sprintf("%s response is undefined when security field is defined", [wantedResponses]),
		"searchValue": sprintf("%s", [wantedResponses]),
		"overrideKey": version,
		"searchValue": sprintf("%s response", [wantedResponses]),
		"searchLine": common_lib.build_search_line(["paths", n, oper, "responses"],[]),
	}
}
