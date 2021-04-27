package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	header := doc.paths[path][operation].responses[r].content[c].encoding[e].headers[h]
	not undefined(header)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.encoding.{{%s}}", [path, operation, r, c, e]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.encoding.{{%s}} does not define 'Content-Type' in the 'headers' field", [path, operation, r, c, e]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.encoding.{{%s}} defines 'Content-Type' in the 'headers' field", [path, operation, r, c, e]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	header := doc.paths[path][operation].requestBody.content[c].encoding[e].headers[h]
	not undefined(header)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.encoding.{{%s}}", [path, operation, c, e]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.encoding.{{%s}} does not define 'Content-Type' in the 'headers' field", [path, operation, c, e]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.encoding.{{%s}} defines 'Content-Type' in the 'headers' field", [path, operation, c, e]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	header := doc.components.requestBodies[r].content[c].encoding[e].headers[h]
	not undefined(header)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.encoding.{{%s}}", [r, c, e]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.encoding.{{%s}} does not define 'Content-Type' in the 'headers' field", [r, c, e]),
		"keyActualValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.encoding.{{%s}} defines 'Content-Type' in the 'headers' field", [r, c, e]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	header := doc.components.responses[r].content[c].encoding[e].headers[h]
	not undefined(header)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}.encoding.{{%s}}", [r, c, e]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.content.{{%s}}.encoding.{{%s}} does not define 'Content-Type' in the 'headers' field", [r, c, e]),
		"keyActualValue": sprintf("components.responses.{{%s}}.content.{{%s}}.encoding.{{%s}} defines 'Content-Type' in the 'headers' field", [r, c, e]),
	}
}

undefined(header) {
	object.get(header, "contentType", "undefined") = "undefined"
}
