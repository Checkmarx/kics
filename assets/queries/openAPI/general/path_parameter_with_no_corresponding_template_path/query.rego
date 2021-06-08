package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	path := doc.paths[name]

	param := path[verb].parameters[p]
	param.in == "path"

	matches := openapi_lib.is_path_template(name)
	count([path_param |
		path_param := trim_right(trim_left(matches[idx], "{"), "}")
		path_param == param.name
	]) == 0

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Path parameter '%s' should have an template path parameter with the same name and 'in' set to 'path'", [param.name]),
		"keyActualValue": sprintf("Path parameter '%s' does not have an template path parameter with the same name and 'in' set to 'path'", [param.name]),
		"overrideKey": version,
	}
}
