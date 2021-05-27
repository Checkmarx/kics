package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)
	types := {"allOf", "oneOf", "anyOf", "not"}
	object.get(value[types[prop]][n], "$ref", "undefined") != "undefined"
	properties := value[types[prop]][n]
	trim_prefix(properties["$ref"], "#/components/schemas/") == path[minus(count(path), 1)]

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s.$ref=%s", [openapi_lib.concat_path(path), types[prop], properties["$ref"]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.%s does not reference own schema", [concat(".", path), types[prop]]),
		"keyActualValue": sprintf("%s.%s reference own schema", [concat(".", path), types[prop]]),
	}
}
