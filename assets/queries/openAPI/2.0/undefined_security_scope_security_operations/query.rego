package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	operationObject := doc.paths[path][operation]
	not is_array(operationObject.security)

	scope := operationObject.security[schemeKey][_]
	openapi_lib.check_scheme(doc, schemeKey, scope, "2.0")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security.{{%s}}", [path, operation, schemeKey]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("scope %s should be defined on 'securityDefinitions'", [scope]),
		"keyActualValue": sprintf("scope %s is not defined on 'securityDefinitions'", [scope]),
		"searchLine": common_lib.build_search_line(["paths", path, operation, "security", schemeKey], []),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	operationObject := doc.paths[path][operation]
	is_array(operationObject.security)

	scope := operationObject.security[s][schemeKey][_]
	openapi_lib.check_scheme(doc, schemeKey, scope, "2.0")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.security", [path, operation]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("scope %s should be defined on 'securityDefinitions'", [scope]),
		"keyActualValue": sprintf("scope %s is not defined on 'securityDefinitions'", [scope]),
		"searchLine": common_lib.build_search_line(["paths", path, operation, "security", s, schemeKey], []),
	}
}
