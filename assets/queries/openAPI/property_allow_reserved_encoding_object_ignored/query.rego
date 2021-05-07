package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	content := doc.paths[path][operation].requestBody.content[x]
	improperly_defined(content, x)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}", [path, operation, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}} is 'application/x-www-form-urlencoded' when 'allowReserved' is set", [path, operation, x]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}} is not 'application/x-www-form-urlencoded' when 'allowReserved' is set", [path, operation, x]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	content := doc.components.requestBodies[r].content[x]
	improperly_defined(content, x)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}", [r, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}} is 'application/x-www-form-urlencoded' when 'allowReserved' is set", [r, x]),
		"keyActualValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}} is not 'application/x-www-form-urlencoded' when 'allowReserved' is set", [r, x]),
	}
}

improperly_defined(content, x) {
	x != "application/x-www-form-urlencoded"
	object.get(content.encoding[e], "allowReserved", "undefined") != "undefined"
}
