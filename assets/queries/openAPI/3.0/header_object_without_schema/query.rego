package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	header := doc.components.headers[h]
	not_defined(header)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.headers.{{%s}}", [h]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("components.headers.{{%s}} has schema defined", [h]),
		"keyActualValue": sprintf("components.headers.{{%s}} does not have schema defined", [h]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	response := doc.paths[path][operation].responses[r]
	openapi_lib.content_allowed(operation, r)
	header_info := check_content_header(response)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.encoding.{{%s}}.headers.{{%s}}}", [path, operation, r, header_info.c, header_info.e, header_info.h]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.encoding.{{%s}}.headers.{{%s}}} has schema defined", [path, operation, r, header_info.c, header_info.e, header_info.h]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.content.{{%s}}.encoding.{{%s}}.headers.{{%s}} does not have schema defined", [path, operation, r, header_info.c, header_info.e, header_info.h]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	header_info := check_content_header(doc.paths[path][operation].requestBody)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.encoding.{{%s}}.headers.{{%s}}", [path, operation, header_info.c, header_info.e, header_info.h]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.encoding.{{%s}}.headers.{{%s}} has schema defined", [path, operation, header_info.c, header_info.e, header_info.h]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}.encoding.{{%s}}.headers.{{%s}} does not have schema defined", [path, operation, header_info.c, header_info.e, header_info.h]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	header_info := check_content_header(doc.components.requestBodies[r])

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.encoding.{{%s}}.headers.{{%s}}", [r, header_info.c, header_info.e, header_info.h]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.encoding.{{%s}}.headers.{{%s}} has schema defined", [r, header_info.c, header_info.e, header_info.h]),
		"keyActualValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.encoding.{{%s}}.headers.{{%s}} does not have schema defined", [r, header_info.c, header_info.e, header_info.h]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	response := doc.components.responses[r]
	header_info := check_content_header(response)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.content.{{%s}}.encoding.{{%s}}.headers.{{%s}}}", [r, header_info.c, header_info.e, header_info.h]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.content.{{%s}}.encoding.{{%s}}.headers.{{%s}}} has schema defined", [r, header_info.c, header_info.e, header_info.h]),
		"keyActualValue": sprintf("components.responses.{{%s}}.content.{{%s}}.encoding.{{%s}}.headers.{{%s}}} does not have schema defined", [r, header_info.c, header_info.e, header_info.h]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	response := doc.components.responses[r]
	not_defined(response.headers[h])

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.responses.{{%s}}.headers.{{%s}}", [r, h]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("components.responses.{{%s}}.headers.{{%s}} has schema defined", [r, h]),
		"keyActualValue": sprintf("components.responses.{{%s}}.headers.{{%s}} does not have schema defined", [r, h]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	response := doc.paths[n][oper].responses[r]
	openapi_lib.content_allowed(oper, r)
	not_defined(response.headers[h])

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.headers.{{%s}}", [n, oper, r, h]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.headers.{{%s}} has schema defined", [n, oper, r, h]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.responses.{{%s}}.headers.{{%s}} does not have schema defined", [n, oper, r, h]),
	}
}

not_defined(header) {
	not common_lib.valid_key(header, "schema")
}

check_content_header(r) = header_info {
	header := r.content[c].encoding[e].headers[h]
	not_defined(header)
	header_info := {"c": c, "e": e, "h": h}
}
