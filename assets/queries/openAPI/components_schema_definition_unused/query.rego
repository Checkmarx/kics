package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	doc.components.schemas[schema]
	openapi_lib.check_reference_exists(doc, schema, "schemas")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.schemas.{{%s}}", [schema]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema should be used as reference somewhere",
		"keyActualValue": "Schema is not used as reference",
	}
}
