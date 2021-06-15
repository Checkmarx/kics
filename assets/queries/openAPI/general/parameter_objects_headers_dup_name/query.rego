package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	param := value.parameters[n]
	param.in == "header"

	dup := check_dup(value.parameters)
	duplicate = cast_set(dup)
	duplicate[_] == lower(param.name)

	p := openapi_lib.concat_path(path)
	parcialSk := openapi_lib.concat_default_value(p, "parameters")
	name := openapi_lib.get_name(p, param.name)

	sk := openapi_lib.get_complete_search_key(n, parcialSk, name)

	result := {
		"documentId": doc.id,
		"searchKey": sk,
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object with location 'header' doesn't have duplicate names",
		"keyActualValue": sprintf("Parameter Object with location 'header' has duplicate names (name=%s)", [duplicate[_]]),
		"overrideKey": version,
	}
}

check_dup(params) = dup {
	nameArr := [x | p := params[_]; p.in == "header"; x := lower(p.name)]
	arr := cast_set(nameArr)
	count(arr) != count(params)
	dup := [y | y := nameArr[i]]
}
