package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

# This two rules verifies schema and schemas without allOf, anyOf and oneOf
CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)
	schema := value.schema
	schema.type == "object"
	issue := test_schema(schema)
	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.schema%s", [openapi_lib.concat_path(path), issue.path]),
		"issueType": issue.type,
		"keyExpectedValue": issue.solution,
		"keyActualValue": issue.message,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	targetObject := doc.components.schemas[schema]
	targetObject.type == "object"
	issue := test_schema(targetObject)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.schemas.{{%s}}%s", [schema, issue.path]),
		"issueType": issue.type,
		"keyExpectedValue": issue.solution,
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
		"keyExpectedValue": issue.solution,
		"keyActualValue": issue.message,
	}
}

test_schema(schema) = issue {
	should_test_schema(schema)

	not common_lib.valid_key(schema, "additionalProperties")

	issue := {
		"type": "MissingAttribute",
		"path": "",
		"message": "'additionalProperties' is not set",
		"solution": "'additionalProperties' needs to be set and to false",
	}
} else = issue {
	should_test_schema(schema)
	schema.additionalProperties == "true"
	issue := {
		"type": "IncorrectValue",
		"path": ".additionalProperties",
		"message": "'additionalProperties' is set true",
		"solution": "'additionalProperties' should be set to false",
	}
}

should_test_schema(schema) {
	not common_lib.valid_key(schema, "anyOf")
	not common_lib.valid_key(schema, "oneOf")
	not common_lib.valid_key(schema, "allOf")
	not common_lib.valid_key(schema, "$ref")
}

get_schema_list(value) = result {
	common_lib.valid_key(value, "anyOf")
	result := {"schemas": value.anyOf, "kind": "anyOf"}
} else = result {
	common_lib.valid_key(value, "oneOf")
	result := {"schemas": value.oneOf, "kind": "oneOf"}
}
