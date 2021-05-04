package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.paths[name].parameters[n]

	improperly_defined(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.parameters.name={{%s}}", [name, params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("openapi.paths.{{%s}}.parameters.name={{%s}} has 'in' set to 'query' when 'allowReserved' is set", [name, params.name]),
		"keyActualValue": sprintf("openapi.paths.{{%s}}.parameters.name={{%s}} does not have 'in' set to 'query' when 'allowReserved' is set", [name, params.name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.paths[name][oper].parameters[n]

	improperly_defined(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.%s.%s.parameters.name={{%s}}", [name, oper, params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("openapi.paths.%s.%s.parameters.name={{%s}} has 'in' set to 'query' when 'allowReserved' is set", [name, oper, params.name]),
		"keyActualValue": sprintf("openapi.paths.%s.%s.parameters.name={{%s}} does not have 'in' set to 'query' when 'allowReserved' is set", [name, oper, params.name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.components.parameters[n]

	improperly_defined(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.components.parameters.name={{%s}}", [params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("openapi.components.parameters.name={{%s}} has 'in' set to 'query' when 'allowReserved' is set", [params.name]),
		"keyActualValue": sprintf("openapi.components.parameters.name={{%s}} does not have 'in' set to 'query' when 'allowReserved' is set", [params.name]),
	}
}

improperly_defined(params) {
	object.get(params, "allowReserved", "undefined") != "undefined"
	params.in != "query"
}
