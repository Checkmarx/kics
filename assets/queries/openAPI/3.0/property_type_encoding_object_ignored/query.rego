package Cx

import data.generic.openapi as openapi_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	content := doc.paths[path][operation].requestBody.content[x]
	improperly_defined(content, x)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}}", [path, operation, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}} should be 'application/x-www-form-urlencoded' when 'style' is set", [path, operation, x]),
		"keyActualValue": sprintf("paths.{{%s}}.{{%s}}.requestBody.content.{{%s}} is not 'application/x-www-form-urlencoded' when 'style' is set", [path, operation, x]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	content := doc.components.requestBodies[r].content[x]
	improperly_defined(content, x)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("components.requestBodies.{{%s}}.content.{{%s}}", [r, x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}} should be 'application/x-www-form-urlencoded' when 'style' is set", [r, x]),
		"keyActualValue": sprintf("components.requestBodies.{{%s}}.content.{{%s}} is not 'application/x-www-form-urlencoded' when 'style' is set", [r, x]),
	}
}

improperly_defined(content, x) {
	x != "application/x-www-form-urlencoded"
	common_lib.valid_key(content.encoding[_], "style")
}
