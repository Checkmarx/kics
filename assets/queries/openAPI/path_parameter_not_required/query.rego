package Cx

import data.generic.openapi as openAPILib

CxPolicy[result] {
	doc := input.document[i]
	openAPILib.checkOpenAPI(doc) != "undefined"
	paths := doc.paths[name]
	param := paths.parameters[n]
	param.in == "path"
	object.get(param, "required", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.parameters.name={{%s}}", [name, param.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Path parameter has the field 'required' and set to 'true' for location 'path'",
		"keyActualValue": "Path parameter field 'required' is missing for location 'path'",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openAPILib.checkOpenAPI(doc) != "undefined"
	paths := doc.paths[name]
	param := paths.parameters[n]
	param.in == "path"
	required := param.required

	not required

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.{{%s}}.parameters.name={{%s}}.required", [name, param.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Path parameter field 'required' is set to 'true' for location 'path'",
		"keyActualValue": "Path parameter field 'required' is set to 'false' for location 'path'",
	}
}
