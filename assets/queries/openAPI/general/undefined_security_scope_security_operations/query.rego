package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	operationObject := doc.paths[path][operation]
	not is_array(operationObject.security)
	opScheme := check_schemes(doc, operationObject.security, version)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security.{{%s}}", [path, operation, opScheme]),
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

	operationObject := doc.paths[path][operation]
	is_array(operationObject.security)

	operationSecuritiesScheme := operationObject.security[_]
	opScheme := check_schemes(doc, operationSecuritiesScheme, version)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Scope should be defined on 'securityShemes'",
		"keyActualValue": "Using an undefined scope",
		"overrideKey": version,
	}
}

check_schemes(doc, opSchemes, version) = opScheme {
	version == "3.0"
	operationSecurityScheme := opSchemes[opScheme]
	secScheme := doc.components.securitySchemes[scheme]
	secScheme.type == "oauth2"

	opScope := operationSecurityScheme[_]
	arr := [x | _ := secScheme.flows[flowKey].scopes[scopeName]; scopeName == opScope; x := opScope]

	count(arr) == 0
} else = opScheme {
	version == "2.0"
	operationSecurityScheme := opSchemes[opScheme]
	secScheme := doc.components.securityDefinitions[scheme]
	secScheme.type == "oauth2"

	opScope := operationSecurityScheme[_]
	arr := [x | _ := secScheme.scopes[scopeName]; scopeName == opScope; x := opScope]

	count(arr) == 0
}
