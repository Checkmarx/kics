package Cx

import data.generic.openapi as openAPILib

CxPolicy[result] {
	doc := input.document[i]
	openAPILib.checkOpenAPI(doc) != "undefined"
	server := doc.servers[n]

	regex.match("^(http:)", server.url)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("openapi.servers.url={{%s}}", [server.url]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "A default security schema should be defined",
		"keyActualValue": "A default security schema is not defined",
	}
}
