package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	docs := input.document[i]
	openapi_lib.check_openapi(docs) != "undefined"

	[path, value] := walk(docs)
	schema = value.schema

	requiredProperty := schema.required[_]

	all([property | property != requiredProperty; _ := schema.properties[property]])
	sk := concat(".", [x | x := resolve_path(path[_])])
	result := {
		"documentId": docs.id,
		"searchKey": sprintf("%s.schema", [sk]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Schema should have all required properties defined",
		"keyActualValue": "Schema has required properties that are not defined",
	}
}

CxPolicy[result] {
	docs := input.document[i]
	openapi_lib.check_openapi(docs) != "undefined"

	[path, value] := walk(docs)
	schema = value.schemas[schemaName]

	requiredProperty := schema.required[_]

	all([property | property != requiredProperty; _ := schema.properties[property]])
	newPath := [path[_], schemaName]
	sk := concat(".", [x | x := resolve_path(newPath[_])])
	result := {
		"documentId": docs.id,
		"searchKey": sprintf("%s.schema", [sk]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Schema should have all required properties defined",
		"keyActualValue": "Schema has required properties that are not defined",
	}
}

resolve_path(pathItem) = resolved {
	any([contains(pathItem, "."), contains(pathItem, "="), contains(pathItem, "/")])
	resolved := sprintf("{{%s}}", [pathItem])
} else = pathItem {
	true
}
