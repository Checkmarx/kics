package Cx

import data.generic.openapi as openAPILib

CxPolicy[result] {
	doc := input.document[i]
	openAPILib.checkOpenAPI(doc) != "undefined"
	params := doc.paths[name].parameters[n]
	object.get(params, "$ref", "undefined") == "undefined"

	not check_params(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.parameters.name={{%s}}", [name, params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object doesn't have both 'schema' and 'content' defined",
		"keyActualValue": "Parameter Object has both 'schema' and 'content' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openAPILib.checkOpenAPI(doc) != "undefined"
	params := doc.components.parameters[n]
	object.get(params, "$ref", "undefined") == "undefined"

	not check_params(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.components.parameters.name={{%s}}", [params.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object doesn't have both 'schema' and 'content' defined",
		"keyActualValue": "Parameter Object has both 'schema' and 'content' defined",
	}
}

check_params(params) {
	object.get(params, "schema", "undefined") == "undefined"
}

check_params(params) {
	object.get(params, "content", "undefined") == "undefined"
}
