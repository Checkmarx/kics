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
		"keyExpectedValue": "A default security schema should be defined",
		"keyActualValue": "A default security schema is not defined",
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
		"keyExpectedValue": "A default security schema should be defined",
		"keyActualValue": "A default security schema is not defined",
	}
}

check_parameters(param) {
	object.get(param, "schema", "undefined") == "undefined"
	object.get(param, "content", "undefined") == "undefined"
}
