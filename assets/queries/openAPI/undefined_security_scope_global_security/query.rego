package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	not is_array(doc.security)
	scheme := check_schemes(doc, doc.security)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("security.{{%s}}", [scheme]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Scope should be defined on 'securityShemes'",
		"keyActualValue": "Using an undefined scope",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	is_array(doc.security)

	securitiesScheme := doc.security[_]
	secFieldScheme := check_schemes(doc, securitiesScheme)

	result := {
		"documentId": doc.id,
		"searchKey": "security",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Scope should be defined on 'securityShemes'",
		"keyActualValue": "Using an undefined scope",
	}
}

check_schemes(doc, secFieldSchemes) = secFieldScheme {
	secFieldSecurityScheme := secFieldSchemes[secFieldScheme]
	secScheme := doc.components.securitySchemes[scheme]
	secScheme.type == "oauth2"

	secScope := secFieldSecurityScheme[_]

	arr := [x | _ := secScheme.flows[flowKey].scopes[scopeName]; scopeName == secScope; x := secScope]

	count(arr) == 0
}
