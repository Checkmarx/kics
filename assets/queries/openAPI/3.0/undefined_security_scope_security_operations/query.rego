package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	operationObject := doc.paths[path][operation]
	not is_array(operationObject.security)
	opScheme := openapi_lib.check_schemes(doc, operationObject.security, "3.0")

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
	openapi_lib.check_openapi(doc) == "3.0"

	operationObject := doc.paths[path][operation]
	is_array(operationObject.security)

	operationSecuritiesScheme := operationObject.security[_]
	opScheme := openapi_lib.check_schemes(doc, operationSecuritiesScheme, "3.0")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Scope should be defined on 'securityShemes'",
		"keyActualValue": "Using an undefined scope",
	}
}
