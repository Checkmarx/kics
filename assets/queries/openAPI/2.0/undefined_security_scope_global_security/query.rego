package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	not is_array(doc.security)

	scope := doc.security[schemeKey][_]
	openapi_lib.check_scheme(doc, schemeKey, scope, "2.0")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("security.{{%s}}", [schemeKey]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("scope %s should be defined on 'securityDefinitions'", [scope]),
		"keyActualValue": sprintf("scope %s is not defined on 'securityDefinitions'", [scope]),
		"searchLine": common_lib.build_search_line(["security", schemeKey], []),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	is_array(doc.security)

	scope := doc.security[s][schemeKey][_]
	openapi_lib.check_scheme(doc, schemeKey, scope, "2.0")

	result := {
		"documentId": doc.id,
		"searchKey": "security",
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("scope %s should be defined on 'securityDefinitions'", [scope]),
		"keyActualValue": sprintf("scope %s is not defined on 'securityDefinitions'", [scope]),
		"searchLine": common_lib.build_search_line(["security", s, schemeKey], []),
	}
}
