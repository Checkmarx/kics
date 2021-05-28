package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	response := doc.paths[path][operation].responses[r]
	openapi_lib.content_allowed(operation, r)
	header_info := check_content_header(response)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.encoding.{{%s}}", [path, operation, r, header_info.c, header_info.e]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.encoding.{{%s}} does not define 'Content-Type' in the 'headers' field", [path, operation, r, header_info.c, header_info.e]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.encoding.{{%s}} defines 'Content-Type' in the 'headers' field", [path, operation, r, header_info.c, header_info.e]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	header_info := check_content_header(doc.paths[path][operation].requestBody)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.encoding.{{%s}}", [path, operation, header_info.c, header_info.e]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.encoding.{{%s}} does not define 'Content-Type' in the 'headers' field", [path, operation, header_info.c, header_info.e]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.encoding.{{%s}} defines 'Content-Type' in the 'headers' field", [path, operation, header_info.c, header_info.e]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	header_info := check_content_header(doc.components.requestBodies[r])

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.encoding.{{%s}}", [r, header_info.c, header_info.e]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.encoding.{{%s}} does not define 'Content-Type' in the 'headers' field", [r, header_info.c, header_info.e]),
		"keyActualValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.encoding.{{%s}} defines 'Content-Type' in the 'headers' field", [r, header_info.c, header_info.e]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	response := doc.components.responses[r]
	header_info := check_content_header(response)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}.encoding.{{%s}}", [r, header_info.c, header_info.e]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.content.{{%s}}.encoding.{{%s}} does not define 'Content-Type' in the 'headers' field", [r, header_info.c, header_info.e]),
		"keyActualValue": sprintf("components.responses.{{%s}}.content.{{%s}}.encoding.{{%s}} defines 'Content-Type' in the 'headers' field", [r, header_info.c, header_info.e]),
	}
}

check_content_header(r) = header_info {
	header := r.content[c].encoding[e].headers[h]
	object.get(header, "contentType", "undefined") != "undefined"
	header_info := {"c": c, "e": e}
}
