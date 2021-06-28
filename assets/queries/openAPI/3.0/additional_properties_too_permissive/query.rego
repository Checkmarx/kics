package Cx

import data.generic.openapi as openapi_lib

# This two rules verifies schema and schemas without allOf, anyOf and oneOf
CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	schema := value.schema
	issue := test_schema(schema)
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.schema%s", [openapi_lib.concat_path(path), issue.path]),
		"issueType": issue.type,
		"keyExpectedValue": "'additionalProperties' is set to true",
		"keyActualValue": issue.message,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	doc.components.schemas[schema]
	issue := test_schema(schema)
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("docs.components.schemas.{{%s}}%s", [schema, issue.path]),
		"issueType": issue.type,
		"keyExpectedValue": "'additionalProperties' is set to true",
		"keyActualValue": issue.message,
	}
}

#This rules verifies anyOf and oneOf
CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	multiSchemas := get_schema_list(value)
	schema := multiSchemas.schemas[_]
	issue := test_schema(schema)
	schema.type != "object"
	schema.type != "array"
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), multiSchemas.kind]),
		"issueType": issue.type,
		"keyExpectedValue": "'additionalProperties' is set to true",
		"keyActualValue": issue.message,
	}
}

test_schema(schema) = issue {
	should_test_schema(schema)
	object.get(schema, "additionalProperties", "undefined") == "undefined"
	issue := {
		"type": "MissingAttribute",
		"path": "",
		"message": "'additionalProperties' is not set",
	}
} else = issue {
	should_test_schema(schema)
	schema.additionalProperties == "true"
	issue := {
		"type": "IncorrectValue",
		"path": ".additionalProperties",
		"message": "'additionalProperties' is set true instead of false",
	}
}

should_test_schema(schema) {
	object.get(schema, "anyOf", "undefined") == "undefined"
	object.get(schema, "oneOf", "undefined") == "undefined"
	object.get(schema, "allOf", "undefined") == "undefined"
	object.get(schema, "$ref", "undefined") == "undefined"
}

get_schema_list(value) = result {
	object.get(value, "anyOf", "undefined") != "undefined"
	result := {"schemas": value.anyOf, "kind": "anyOf"}
} else = result {
	object.get(value, "oneOf", "undefined") != "undefined"
	result := {"schemas": value.oneOf, "kind": "oneOf"}
}
