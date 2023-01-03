package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	params := doc.paths[name].parameters[n]

	improperly_defined(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.parameters.name={{%s}}", [name, params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.parameters.name={{%s}} should have 'in' set to 'query' when 'allowReserved' is set", [name, params.name]),
		"keyActualValue": sprintf("paths.{{%s}}.parameters.name={{%s}} does not have 'in' set to 'query' when 'allowReserved' is set", [name, params.name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	params := doc.paths[name][oper].parameters[n]

	improperly_defined(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s.%s.parameters.name={{%s}}", [name, oper, params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.%s.%s.parameters.name={{%s}} should have 'in' set to 'query' when 'allowReserved' is set", [name, oper, params.name]),
		"keyActualValue": sprintf("paths.%s.%s.parameters.name={{%s}} does not have 'in' set to 'query' when 'allowReserved' is set", [name, oper, params.name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	params := doc.components.parameters[n]

	improperly_defined(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.components.parameters.name={{%s}}", [params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("openapi.components.parameters.name={{%s}} should have 'in' set to 'query' when 'allowReserved' is set", [params.name]),
		"keyActualValue": sprintf("openapi.components.parameters.name={{%s}} does not have 'in' set to 'query' when 'allowReserved' is set", [params.name]),
	}
}

improperly_defined(params) {
	common_lib.valid_key(params, "allowReserved")
	params.in != "query"
}
