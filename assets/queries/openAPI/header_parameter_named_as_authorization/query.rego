package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.paths[name].parameters[n]

	openapi_lib.improperly_defined(params, "Authorization")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.parameters.name={{%s}}", [name, params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("openapi.paths.{{%s}}.parameters.name={{%s}} is not 'Authorization'", [name, params.name]),
		"keyActualValue": sprintf("openapi.paths.{{%s}}.parameters.name={{%s}} is 'Authorization'", [name, params.name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.paths[name][oper].parameters[n]

	openapi_lib.improperly_defined(params, "Authorization")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.%s.%s.parameters.name={{%s}}", [name, oper, params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("openapi.paths.%s.%s.parameters.name={{%s}} is not 'Authorization'", [name, oper, params.name]),
		"keyActualValue": sprintf("openapi.paths.%s.%s.parameters.name={{%s}} is 'Authorization'", [name, oper, params.name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.components.parameters[n]

	openapi_lib.improperly_defined(params, "Authorization")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.components.parameters.name={{%s}}", [params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("openapi.components.parameters.name={{%s}} is not 'Authorization'", [params.name]),
		"keyActualValue": sprintf("openapi.components.parameters.name={{%s}} is 'Authorization'", [params.name]),
	}
}
