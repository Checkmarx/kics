package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.paths[n].parameters

	dup := check_dup(params)
	duplicate = cast_set(dup)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.%s.parameters.name=%s", [n, duplicate[_]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object with location 'header' doesn't have duplicate names",
		"keyActualValue": "Parameter Object with location 'header' has duplicate names",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.paths[n][oper].parameters

	dup := check_dup(params)
	duplicate = cast_set(dup)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.paths.%s.%s.parameters.name=%s", [n, oper, duplicate[_]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object with location 'header' doesn't have duplicate names",
		"keyActualValue": "Parameter Object with location 'header' has duplicate names",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
	params := doc.components.parameters

	dup := check_dup(params)
	duplicate = cast_set(dup)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.components.parameters.%s", [duplicate[_]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object with location 'header' doesn't have duplicate names",
		"keyActualValue": "Parameter Object with location 'header' has duplicate names",
	}
}

check_dup(params) = dup {
	is_object(params)
	nameArr := [x | p := params[name]; p.in == "header"; x := lower(name)]
	arr := cast_set(nameArr)
	count(arr) != count(params)
	dup := [y | y := nameArr[i]]
}

check_dup(params) = dup {
	is_array(params)
	nameArr := [x | p := params[n]; p.in == "header"; x := lower(p.name)]
	arr := cast_set(nameArr)
	count(arr) != count(params)
	dup := [y | y := nameArr[i]]
}
