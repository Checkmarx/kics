package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.paths[n].parameters

	check_dup(params)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.%s.parameters", [n]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object with location 'header', doesn't have duplicate names",
		"keyActualValue": "Parameter Object with location 'header', has duplicate names",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.components.parameters

	check_dup(params)

	result := {
		"documentId": doc.id,
		"searchKey": "openapi.components.parameters",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object with location 'header', doesn't have duplicate names",
		"keyActualValue": "Parameter Object with location 'header', has duplicate names",
	}
}

check_dup(params) {
	is_object(params)
	nameArr := [x | p := params[name]; p.in == "header"; x := lower(name)]
	arr := cast_set(nameArr)
	count(arr) != count(params)
}

check_dup(params) {
	is_array(params)
	nameArr := [x | p := params[n]; p.in == "header"; x := lower(p.name)]
	arr := cast_set(nameArr)
	count(arr) != count(params)
}
