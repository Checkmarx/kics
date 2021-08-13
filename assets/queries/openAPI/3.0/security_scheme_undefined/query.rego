package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	not common_lib.valid_key(doc, "components")

	result := {
		"documentId": doc.id,
		"searchKey": "openapi",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "A security scheme on components should be defined",
		"keyActualValue": "Components is not defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	common_lib.valid_key(doc, "components")
	not common_lib.valid_key(doc.components, "securitySchemes")

	result := {
		"documentId": doc.id,
		"searchKey": "components",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "A security scheme on components should be defined",
		"keyActualValue": "A security scheme is not defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	common_lib.valid_key(doc, "components")
	common_lib.valid_key(doc.components, "securitySchemes")

	doc.components.securitySchemes == {}

	result := {
		"documentId": doc.id,
		"searchKey": "components.securitySchemes",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "A security scheme on components should be defined",
		"keyActualValue": "A security scheme is an empty object",
	}
}
