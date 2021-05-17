package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	openapi_lib.is_basic_authentication(doc.components.securitySchemes)

	server := doc.servers[j]
	openapi_lib.is_unsecure_http(server.url)

	sec := doc.security[k][schemeName]
	is_array(sec)
	sec == []

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("security.{{%s}}", [schemeName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("security.{{%s}} should not allow cleartext credentials over unencrypted channel", [schemeName]),
		"keyActualValue": sprintf("security.{{%s}} allows cleartext credentials over unencrypted channel", [schemeName]),
	}
}
