package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

    openapi_lib.is_basic_authentication(doc.components.securitySchemes)

    server := doc.servers[j]
    openapi_lib.is_unsecure_http(server.url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("servers.url={{%s}}", [server.url]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("servers.url=%s global security should not allow cleartext credentials over unencrypted channel", [server.url]),
		"keyActualValue": sprintf("servers.url=%s global security allows cleartext credentials over unencrypted channel", [server.url]),
	}
}
