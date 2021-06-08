package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	docs := input.document[i]
	version := openapi_lib.check_openapi(docs)
	version != "undefined"

	[path, value] := walk(docs)
	schema = value.schema

	requiredProperty := schema.required[_]

	all([property | property != requiredProperty; _ := schema.properties[property]])
	result := {
		"documentId": docs.id,
		"searchKey": sprintf("%s.schema", [openapi_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Schema should have all required properties defined",
		"keyActualValue": "Schema has required properties that are not defined",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	docs := input.document[i]
	version := openapi_lib.check_openapi(docs)
	version != "undefined"

	[path, value] := walk(docs)
	schema = value.schemas[schemaName]

	requiredProperty := schema.required[_]

	all([property | property != requiredProperty; _ := schema.properties[property]])
	newPath := [path[_], schemaName]
	result := {
		"documentId": docs.id,
		"searchKey": sprintf("%s.schema", [openapi_lib.concat_path(newPath)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Schema should have all required properties defined",
		"keyActualValue": "Schema has required properties that are not defined",
		"overrideKey": version,
	}
}
