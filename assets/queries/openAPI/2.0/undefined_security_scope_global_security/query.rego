package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	not is_array(doc.security)
	scheme := openapi_lib.check_schemes(doc, doc.security, "2.0")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("security.{{%s}}", [scheme]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Scope should be defined on 'securityDefinition'",
		"keyActualValue": "Using an undefined scope",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	is_array(doc.security)

	securitiesScheme := doc.security[_]
	secFieldScheme := openapi_lib.check_schemes(doc, securitiesScheme, "2.0")

	result := {
		"documentId": doc.id,
		"searchKey": "security",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Scope should be defined on 'securityDefinition'",
		"keyActualValue": "Using an undefined scope",
	}
}
