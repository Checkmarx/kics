package Cx

import data.generic.openapi as openapi_lib

numeric := {"integer", "number"}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].responses[r].content[c].schema
	openapi_lib.content_allowed(operation, r)
	openapi_lib.undefined_properties_in_schema(doc, schema, numeric[x], "maximum")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.schema", [path, operation, r, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Numeric schema has 'maximum' defined",
		"keyActualValue": "Numeric schema does not have 'maximum' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path].parameters[parameter].schema
	openapi_lib.undefined_properties_in_schema(doc, schema, numeric[x], "maximum")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.parameters.{{%s}}.schema", [path, parameter]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Numeric schema has 'maximum' defined",
		"keyActualValue": "Numeric schema does not have 'maximum' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].parameters[parameter].schema
	openapi_lib.undefined_properties_in_schema(doc, schema, numeric[x], "maximum")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.parameters.{{%s}}.schema", [path, operation, parameter]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Numeric schema has 'maximum' defined",
		"keyActualValue": "Numeric schema does not have 'maximum' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.paths[path][operation].requestBody.content[c].schema
	openapi_lib.undefined_properties_in_schema(doc, schema, numeric[x], "maximum")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.schema", [path, operation, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Numeric schema has 'maximum' defined",
		"keyActualValue": "Numeric schema does not have 'maximum' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.requestBodies[r].content[c].schema
	openapi_lib.undefined_properties_in_schema(doc, schema, numeric[x], "maximum")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.schema", [r, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Numeric schema has 'maximum' defined",
		"keyActualValue": "Numeric schema does not have 'maximum' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.parameters[parameter].schema
	openapi_lib.undefined_properties_in_schema(doc, schema, numeric[x], "maximum")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.parameters.{{%s}}.schema", [parameter]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Numeric schema has 'maximum' defined",
		"keyActualValue": "Numeric schema does not have 'maximum' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	schema := doc.components.responses[r].content[c].schema
	openapi_lib.undefined_properties_in_schema(doc, schema, numeric[x], "maximum")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}.schema", [r, c]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Numeric schema has 'maximum' defined",
		"keyActualValue": "Numeric schema does not have 'maximum' defined",
	}
}
