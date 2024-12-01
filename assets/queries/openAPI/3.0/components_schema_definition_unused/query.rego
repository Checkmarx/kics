package Cx

import data.generic.openapi as openapi_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	openapi_lib.check_openapi(doc) == "3.0"

	doc.components.schemas[schema]
	openapi_lib.check_unused_reference(doc, schema, "schemas")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.schemas.{{%s}}", [schema]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Schema should be used as reference somewhere",
		"keyActualValue": "Schema is not used as reference",
	}
}
