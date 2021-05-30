package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] := walk(doc)
	params := value.parameters

	dup := check_dup(params)
	duplicate = cast_set(dup)

	sk := get_search_key(path)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf(sk, [openapi_lib.concat_path(path), duplicate[_]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object with location 'header' doesn't have duplicate names",
		"keyActualValue": "Parameter Object with location 'header' has duplicate names",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"
	def := doc.definitions[paramName]
	defComp := doc.definitions[paramCompName]

	paramName != paramCompName
	def.in == "header"
	defComp.in == "header"
	def.name == defComp.name

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("definitions.%s.name", [paramName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Parameter Object with location 'header' doesn't have duplicate names",
		"keyActualValue": "Parameter Object with location 'header' has duplicate names",
		"overrideKey": version,
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

get_search_key(path) = searchKey {
	path[minus(count(path), 1)] == "components"
	searchKey := "%s.parameters.%s"
} else = searchKey {
	searchKey := "%s.parameters.name=%s"
}
