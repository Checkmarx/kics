package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"
    object.get(doc, "servers", "undefined") == "undefined"

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
	openapi_lib.check_openapi(doc) != "undefined"
	object.get(doc, "servers", "undefined") != "undefined"

    count(doc.servers) > 0
    object.get(doc.servers[j], "url", "undefined") != "undefined"
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
