package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.paths[name].parameters[n]
	object.get(params, "$ref", "undefined") == "undefined"

	check_parameters(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.parameters.name={{%s}}", [name, params.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("openapi.paths.{{%s}}.parameters type should be defined", [name, params.name]),
		"keyActualValue": sprintf("openapi.paths.{{%s}}.parameters type is not defined", [name, params.name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.components.parameters[n]
	object.get(params, "$ref", "undefined") == "undefined"

	check_parameters(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.components.parameters.name={{%s}}", [params.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("openapi.components.parameters type should be defined", [params.name]),
		"keyActualValue": sprintf("openapi.components.parameters type is not defined", [params.name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.paths[name][oper].parameters[n]
	object.get(params, "$ref", "undefined") == "undefined"

	check_parameters(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.{{%s}}.parameters.name={{%s}}", [name, oper, params.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("openapi.paths.{{%s}}.{{%s}}.parameters type should be defined", [name, oper, params.name]),
		"keyActualValue": sprintf("openapi.paths.{{%s}}.{{%s}}.parameters type is not defined", [name, oper, params.name]),
	}
}

check_parameters(param) {
	object.get(param, "schema", "undefined") == "undefined"
	object.get(param, "content", "undefined") == "undefined"
}
