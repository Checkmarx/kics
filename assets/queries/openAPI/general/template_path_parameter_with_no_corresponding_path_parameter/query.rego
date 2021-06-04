package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	path := doc.paths[name]
	matches := openapi_lib.is_path_template(name)
	matches != []
	path_param := trim_right(trim_left(matches[idx], "{"), "}")
	parameter := path[verb].parameters[param]

	count([parameter |
		parameter.in == "path"
		parameter.name == path_param
		parameter := path[verb].parameters[param]
	]) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s.%s.parameters.name=%s", [name, verb, parameter.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Template path parameter should have an operation parameter with the same name and 'in' set to 'path'",
		"keyActualValue": "Template path parameter does not have an operation parameter with the same name and 'in' set to 'path'",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	path := doc.paths[name]
	matches := openapi_lib.is_path_template(name)
	matches != []
	path[verb].parameters == {}

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s.%s.parameters", [name, verb]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Template path parameters should be defined for operation",
		"keyActualValue": "Template path parameters is not defined for operation",
		"overrideKey": version,
	}
}
