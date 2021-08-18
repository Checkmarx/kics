package Cx

import data.generic.common as common_lib
import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	object.get(doc, "components", "undefined") == "undefined"

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
	object.get(doc, "components", "undefined") != "undefined"
	object.get(doc.components, "securitySchemes", "undefined") == "undefined"

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
	object.get(doc, "components", "undefined") != "undefined"
	object.get(doc.components, "securitySchemes", "undefined") != "undefined"

	# doc.components.securitySchemes == {}
	common_lib.check_obj_empty(doc.components.securitySchemes)

	result := {
		"documentId": doc.id,
		"searchKey": "components.securitySchemes",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "A security scheme on components should be defined",
		"keyActualValue": "A security scheme is an empty object",
	}
}
