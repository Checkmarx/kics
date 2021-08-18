package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	not common_lib.valid_key(doc, "servers")

	result := {
		"documentId": doc.id,
		"searchKey": "openapi",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Global servers array should be defined",
		"keyActualValue": "Global servers array is not defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"
	common_lib.valid_key(doc, "servers")

	count(doc.servers) > 0
	common_lib.valid_key(doc.servers[j], "url")
	serverObj := doc.servers[j]
	not startswith(serverObj.url, "https")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("servers.url.%s", [serverObj.url]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Global servers' URL should use HTTPS protocol",
		"keyActualValue": "Global servers' URL are not using HTTPS protocol",
	}
}
