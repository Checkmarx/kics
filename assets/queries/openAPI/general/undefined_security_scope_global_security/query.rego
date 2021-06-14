package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	not is_array(doc.security)
	scheme := check_schemes(doc, doc.security, version)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("security.{{%s}}", [scheme]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Scope should be defined on 'securityShemes'",
		"keyActualValue": "Using an undefined scope",
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	is_array(doc.security)

	securitiesScheme := doc.security[_]
	secFieldScheme := check_schemes(doc, securitiesScheme, version)

	result := {
		"documentId": doc.id,
		"searchKey": "security",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Scope should be defined on 'securityShemes'",
		"keyActualValue": "Using an undefined scope",
		"overrideKey": version,
	}
}

check_schemes(doc, secFieldSchemes, version) = secFieldScheme {
	version == "3.0"
	secFieldSecurityScheme := secFieldSchemes[secFieldScheme]
	secScheme := doc.components.securitySchemes[scheme]
	secScheme.type == "oauth2"

	secScope := secFieldSecurityScheme[_]

	arr := [x | _ := secScheme.flows[flowKey].scopes[scopeName]; scopeName == secScope; x := secScope]

	count(arr) == 0
} else = secFieldScheme {
	version == "2.0"
	secFieldSecurityScheme := secFieldSchemes[secFieldScheme]
	secScheme := doc.components.securityDefinitions[scheme]
	secScheme.type == "oauth2"

	secScope := secFieldSecurityScheme[_]

	arr := [x | _ := secScheme.scopes[scopeName]; scopeName == secScope; x := secScope]

	count(arr) == 0
}
