package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	params := doc.paths[name].parameters[n]
	not common_lib.valid_key(params, "$ref")

	check_parameters(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.parameters.name={{%s}}", [name, params.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.parameters type should be defined", [name, params.name]),
		"keyActualValue": sprintf("paths.{{%s}}.parameters type is not defined", [name, params.name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	params := doc.components.parameters[n]
	not common_lib.valid_key(params, "$ref")

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
	openapi_lib.check_openapi(doc) == "3.0"
	params := doc.paths[name][oper].parameters[n]
	not common_lib.valid_key(params, "$ref")

	check_parameters(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.parameters.name={{%s}}", [name, oper, params.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.parameters type should be defined", [name, oper, params.name]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.parameters type is not defined", [name, oper, params.name]),
	}
}

check_parameters(param) {
	not common_lib.valid_key(param, "schema")
	not common_lib.valid_key(param, "content")
}
