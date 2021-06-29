package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)

	value.allowEmptyValue == true
	allow_empty_value_ignored(value)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.allowEmptyValue", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Property 'allowEmptyValue' is not ignored",
		"keyActualValue": "Property 'allowEmptyValue' is ignored (due to one of the following cases: {\"sytle\": \"simple\", \"explode\": false}, {\"sytle\": \"simple\", \"explode\": true}, {\"sytle\": \"spaceDelimited\", \"explode\": false}, {\"sytle\": \"pipeDelimited\", \"explode\": false}, or {\"sytle\": \"deepObject\", \"explode\": true})",
	}
}

check_simple(value) {
	value.style == "simple"
} else {
	ins := {"path", "header"}
	value.in == ins[_]
	object.get(value, "style", "undefined") == "undefined"
}

set_to_false(value) {
	value.explode == false
} else {
	object.get(value, "explode", "undefined") == "undefined"
}

check_delimited(value) {
	styles := {"spaceDelimited", "pipeDelimited"}
	value.style == styles[_]
	set_to_false(value)
}

allow_empty_value_ignored(value) {
	check_simple(value)
} else {
	check_delimited(value)
} else {
	value.style == "deepObject"
	value.explode == true
}
