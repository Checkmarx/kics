package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	content := doc.paths[path][operation].requestBody.content[x]
	incorrect_media_type(content, x)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}", [path, operation, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}} is 'multipart' or 'application/x-www-form-urlencoded' when 'encoding' is set", [path, operation, x]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}} is not 'multipart' or 'application/x-www-form-urlencoded' when 'encoding' is set", [path, operation, x]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	content := doc.components.requestBodies[r].content[x]
	incorrect_media_type(content, x)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}.encoding.{{%s}}", [r, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}} is 'multipart' or 'application/x-www-form-urlencoded' when 'encoding' is set", [r, x]),
		"keyActualValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}} is not 'multipart' or 'application/x-www-form-urlencoded' when 'encoding' is set", [r, x]),
	}
}

incorrect_media_type(content, media_type) {
	object.get(content, "encoding", "undefined") != "undefined"

	media_types := {"multipart/", "application/x-www-form-urlencoded"}
	count({x | m := media_types[x]; startswith(media_type, m) == true}) == 0
}
