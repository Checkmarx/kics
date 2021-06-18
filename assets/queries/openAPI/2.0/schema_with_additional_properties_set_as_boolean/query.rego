package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)
	is_boolean(value.schema.additionalProperties)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.schema.additionalProperties", [openapi_lib.concat_path(path)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'additionalProperties' is not set as a boolean value",
		"keyActualValue": "'additionalProperties' is set as a boolean value",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	schema := doc.definitions[s]
	is_boolean(schema.additionalProperties)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("definitions.{{%s}}.additionalProperties", [s]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'additionalProperties' is not set as a boolean value",
		"keyActualValue": "'additionalProperties' is set as a boolean value",
	}
}
