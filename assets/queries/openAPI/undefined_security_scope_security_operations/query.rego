package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	operationObject := doc.paths[path][operation]
	not is_array(operationObject.security)
	opScheme := check_schemes(doc, operationObject.security)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security.{{%s}}", [path, operation, opScheme]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Scope should be defined on 'securityShemes'",
		"keyActualValue": "Using an undefined scope",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	operationObject := doc.paths[path][operation]
	is_array(operationObject.security)

	operationSecuritiesScheme := operationObject.security[_]
	opScheme := check_schemes(doc, operationSecuritiesScheme)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Scope should be defined on 'securityShemes'",
		"keyActualValue": "Using an undefined scope",
	}
}

check_schemes(doc, opSchemes) = opScheme {
	operationSecurityScheme := opSchemes[opScheme]
	secScheme := doc.components.securitySchemes[scheme]
	secScheme.type == "oauth2"

	opScope := operationSecurityScheme[_]

	arr := [x | _ := secScheme.flows[flowKey].scopes[scopeName]; scopeName == opScope; x := opScope]

	count(arr) == 0
}
