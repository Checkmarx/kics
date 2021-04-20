package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
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
	openapi_lib.check_openapi(doc) != "undefined"
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
	openapi_lib.check_openapi(doc) != "undefined"
	object.get(doc, "components", "undefined") != "undefined"
	object.get(doc.components, "securitySchemes", "undefined") != "undefined"

	doc.components.securitySchemes == {}

	result := {
		"documentId": doc.id,
		"searchKey": "components.securitySchemes",
		"issueType": "IncorretValue",
		"keyExpectedValue": "A security scheme on components should be defined",
		"keyActualValue": "A security scheme is an empty object",
	}
}
